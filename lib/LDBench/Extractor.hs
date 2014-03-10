module LDBench.Extractor where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.Image

class Extractor e f where
  extract :: e -> Image -> [KeyPoint] -> OpenCVComputation [Maybe f]
  extractSingle :: e -> Image -> KeyPoint -> OpenCVComputation (Maybe f)
