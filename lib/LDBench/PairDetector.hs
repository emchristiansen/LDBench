module LDBench.PairDetector where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.Image
import LDBench.ImageBijection

class PairDetector d where
  detectPairs :: ImageBijection b => d -> b -> Image -> Image -> OpenCVComputation [(KeyPoint, KeyPoint)]
