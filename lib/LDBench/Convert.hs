module LDBench.Convert where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core
import OpenCVThrift.OpenCV.Core.MatUtil
import Codec.Picture hiding (Image)
import Codec.Picture.Types hiding (Image)
import qualified Data.Vector as V
import qualified Data.Vector.Storable as S
import Data.Word

import LDBench.Image

imageToMatUnpacked :: Image -> MatUnpacked
imageToMatUnpacked image = 
  let 
    pixels :: [Word8]
    pixels = S.toList $ imageData image
    {-pixelToVector :: PixelRGB8 -> V.Vector Word8-}
    {-pixelToVector (PixelRGB8 red green blue) = V.fromList $ [red, green, blue]-}
  in
    MatUnpacked
      (Just $ fromIntegral $ imageHeight image)
      (Just $ fromIntegral $ imageWidth image)
      (Just 3)
      (Just $ V.map fromIntegral $ V.fromList pixels)

imageToMat :: Image -> OpenCVComputation Mat
imageToMat image = convert2 pack T8UC3 (imageToMatUnpacked image)
