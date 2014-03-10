module LDBench.Convert where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core
import OpenCVThrift.OpenCV.Core.MatUtil

import LDBench.Image

imageToMatUnpacked :: Image -> MatUnpacked
imageToMatUnpacked = undefined

imageToMat :: Image -> OpenCVComputation Mat
imageToMat image = convert2 pack T8UC3 (imageToMatUnpacked image)
