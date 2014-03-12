module LDBench.Experiments.WideBaseline.Oxford where

import Control.Lens
import Control.Monad
import System.FilePath.Posix
import Text.Printf
import Data.List

import OpenCVThrift.OpenCV

import LDBench.Util
import LDBench.PairDetector
import LDBench.Extractor
import LDBench.Matcher
import LDBench.Experiments.WideBaseline.Results
import LDBench.Experiments.WideBaseline.Experiment
import LDBench.Experiments.WideBaseline.Util
import LDBench.Experiments.WideBaseline.Homography
import LDBench.Experiments.RuntimeConfig
import LDBench.Image
import LDBench.ImageBijection

{-foo :: forall a f. (Num a, Num f) => a -> f-}
{-foo = undefined-}

data Oxford d e m = forall f. (PairDetector d, Extractor e f, Matcher m f) => Oxford
  { _imageClass :: String
  , _otherImage :: Int
  , _maxPairedDescriptors :: Int
  , _detector :: d
  , _extractor :: e
  , _matcher :: m 
  }

dataRoot :: Oxford d e m -> RuntimeConfig -> FilePath
dataRoot oxford runtimeConfig = joinPath
  [ runtimeConfig ^. _dataRootLens
  , "oxfordImages"
  , _imageClass oxford
  ]

readLeftImage :: Oxford d e m -> RuntimeConfig -> IO Image
readLeftImage oxford runtimeConfig = do
  let 
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "images/image1.bmp"
      ]
  putStrLn $ printf "Loading %s" path
  readImage path

readRightImage :: Oxford d e m -> RuntimeConfig -> IO Image
readRightImage oxford runtimeConfig = do
  let 
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "images"
      , printf "image%d" $ _otherImage oxford
      ]
  putStrLn $ printf "Loading %s" path
  readImage path

imageBijection :: Oxford d e m -> RuntimeConfig -> IO Homography
imageBijection oxford runtimeConfig = do
  let
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "homographies"
      , printf "H1to%dp" $ _otherImage oxford
      ]
  putStrLn $ printf "Loading %s" path
  readHomography path 

liftIO' :: IO a -> OpenCVComputation a
liftIO' x = OpenCVComputation $ \_ -> x

instance Experiment (Oxford d e m) where
  run
    oxford @ (Oxford
      imageClass
      otherImage
      maxPairedDescriptors
      detector
      extractor
      matcher)
    runtimeConfig = do
      image0 <- liftIO' $ readLeftImage oxford runtimeConfig
      image1 <- liftIO' $ readRightImage oxford runtimeConfig
      homography <- liftIO' $ imageBijection oxford runtimeConfig
      (keyPoint0s, keyPoint1s) <- liftM unzip $ detectPairs detector homography image0 image1
      descriptors0 <- extract extractor image0 keyPoint0s 

      undefined
