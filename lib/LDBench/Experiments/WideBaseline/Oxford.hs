module LDBench.Experiments.WideBaseline.Oxford where

import Control.Lens
import System.FilePath.Posix
import Text.Printf

import LDBench.Util
import LDBench.PairDetector
import LDBench.Extractor
import LDBench.Matcher
import LDBench.Experiments.WideBaseline.Results
import LDBench.Experiments.WideBaseline.Experiment
import LDBench.Experiments.RuntimeConfig
import LDBench.Image
import LDBench.ImageBijection

data Oxford d e m f = (PairDetector d, Extractor e f, Matcher m f) => Oxford
  { _imageClass :: String
  , _otherImage :: Int
  , _maxPairedDescriptors :: Int
  , _detector :: d
  , _extractor :: e
  , _matcher :: m 
  }

dataRoot :: Oxford d e m f -> RuntimeConfig -> FilePath
dataRoot oxford runtimeConfig = joinPath
  [ runtimeConfig ^. _dataRootLens
  , "oxfordImages"
  , _imageClass oxford
  ]

leftImage :: Oxford d e m f -> RuntimeConfig -> IO Image
leftImage oxford runtimeConfig = do
  let 
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "images/image1.bmp"
      ]
  readImage path

rightImage :: Oxford d e m f -> RuntimeConfig -> IO Image
rightImage oxford runtimeConfig = do
  let 
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "images"
      , printf "image%d" $ _otherImage oxford
      ]
  readImage path

imageBijection :: (ImageBijection b) => Oxford d e m f -> RuntimeConfig -> IO b
imageBijection oxford runtimeConfig = do
  let
    path = joinPath
      [ dataRoot oxford runtimeConfig
      , "homographies"
      , printf "H1to%dp" $ _otherImage oxford
      ]
  undefined

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
