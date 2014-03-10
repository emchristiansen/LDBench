module LDBench.ImageBijection where

import OpenCVThrift.OpenCV.Core

class ImageBijection b where
  leftToRight :: b -> KeyPoint -> KeyPoint
  rightToLeft :: b -> KeyPoint -> KeyPoint
