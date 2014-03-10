module LDBench.Experiments.WideBaseline.Oxford where

import Control.Lens

import LDBench.PairDetector
import LDBench.Extractor
import LDBench.Matcher
import LDBench.Experiments.WideBaseline.Results
import LDBench.Experiments.WideBaseline.Experiment

data Oxford d e m f = (PairDetector d, Extractor e f, Matcher m f) => Oxford
  { _imageClass :: String
  , _otherImage :: Int
  , _maxPairedDescriptors :: Int
  , _detector :: d
  , _extractor :: e
  , _matcher :: m 
  }

instance Experiment (Oxford d e m f) where
  run
    (Oxford
      imageClass
      otherImage
      maxPairedDescriptors
      detector
      extractor
      matcher)
    runtimeConfig = undefined
