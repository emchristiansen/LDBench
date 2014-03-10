module LDBench.Extractor where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.Image

type Extract f = Image -> [KeyPoint] -> OpenCVComputation [Maybe f]
type ExtractSingle f = Image -> KeyPoint -> OpenCVComputation (Maybe f)

class Extractor e f where
  extract :: e -> Extract f
  extractSingle :: e -> ExtractSingle f
