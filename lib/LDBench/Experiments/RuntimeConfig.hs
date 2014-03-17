module LDBench.Experiments.RuntimeConfig where

import Data.Typeable
import Control.Lens
import Control.Lens.TH

{-data RuntimeConfig = RuntimeConfig-}
  {-{ dataRoot :: FilePath-}
  {-, database :: String-}
  {-, outputRoot :: FilePath-}
  {-, tempRoot :: FilePath-}
  {-, matlabLibraryRoot :: FilePath-}
  {-, deleteTemporaryFiles :: Bool-}
  {-, skipCompletedExperiments :: Bool-}
  {-} deriving (Show)-}

declareFields [d|
  data RuntimeConfig = RuntimeConfig
    { _dataRoot :: FilePath
    , _database :: Maybe String
    , _outputRoot :: FilePath
    , _tempRoot :: Maybe FilePath
    , _matlabLibraryRoot :: Maybe FilePath
    , _deleteTemporaryFiles :: Bool
    , _skipCompletedExperiments :: Bool
    } deriving (Show, Typeable)
  |]
