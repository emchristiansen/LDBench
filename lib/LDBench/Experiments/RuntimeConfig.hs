module LDBench.Experiments.RuntimeConfig where

import Control.Lens
import Control.Lens.TH

declareFields [d|
  data RuntimeConfig = RuntimeConfig
    { dataRoot :: FilePath
    , database :: String
    , outputRoot :: FilePath
    , tempRoot :: FilePath
    , matlabLibraryRoot :: FilePath
    , deleteTemporaryFiles :: Bool
    , skipCompletedExperiments :: Bool
    } deriving (Show)
  |]
