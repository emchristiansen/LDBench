module LDBench.ImageBijection where

import OpenCVThrift.OpenCV.Core

class ImageBijection b where
  leftToRight :: b -> Point2d -> Point2d
  rightToLeft :: b -> Point2d -> Point2d
