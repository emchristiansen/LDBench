module LDBench.Util where

import Control.Monad
import Data.Maybe
import Codec.Picture hiding (Image, readImage)
import qualified Codec.Picture as CP
import Codec.Picture.Types hiding (Image)
import Control.Arrow ((&&&))
--import Data.ByteString.Lazy (toStrict)
--import System.IO
--import Control.Concurrent (threadDelay)
--import System.Random
import Data.Word (Word8)
import Data.Vector.Storable (Vector)
import Text.Printf
import OpenCVThrift.OpenCV

import OpenCVThrift.OpenCV.Core
import LDBench.Image

transcodeToImageRGBA8 :: DynamicImage -> Maybe Image
transcodeToImageRGBA8 dynamicImage = case dynamicImage of
  ImageY8 image -> Just $ promoteImage image
  ImageYA8 image -> Just $ promoteImage image
  ImageRGB8 image -> Just $ promoteImage image
  ImageRGBA8 image -> Just $ promoteImage image
  ImageYCbCr8 image -> Just $ 
    promoteImage (convertImage image :: CP.Image PixelRGB8)
  ImageCMYK8 image -> Just $ 
    promoteImage (convertImage image :: CP.Image PixelRGB8)
  _ -> Nothing

-- Attempts to read an `ImageRGBA8` from the given `FilePath`.
readImageSafe :: FilePath -> IO (Maybe Image)
readImageSafe filePath = do
  putStrLn $ "Reading " ++ filePath
  eitherImage <- CP.readImage filePath
  case eitherImage of
  	Right image -> case transcodeToImageRGBA8 image of
  	  Nothing -> do
  	    putStrLn $ "Could not transcode image to PNG, skipping: " ++ filePath
  	    return Nothing
  	  transcoded -> return transcoded
  	Left errorMessage -> do
  	  let formatString = "Failed to read %s with error: %s.\nSkipping."
  	  putStrLn $ printf formatString filePath errorMessage
  	  return Nothing

readImage :: FilePath -> IO Image
readImage = liftM fromJust . readImageSafe

l2Distance :: KeyPoint -> KeyPoint -> Double
l2Distance keyPoint0 keyPoint1 = 
  let
    Just (Point2d (Just x0) (Just y0)) = f_KeyPoint_pt keyPoint0
    Just (Point2d (Just x1) (Just y1)) = f_KeyPoint_pt keyPoint1
  in
    sqrt $ (x0 - x1) ** 2 + (y0 - y1) ** 2

liftIO' :: IO a -> OpenCVComputation a
liftIO' x = OpenCVComputation $ \_ -> x
