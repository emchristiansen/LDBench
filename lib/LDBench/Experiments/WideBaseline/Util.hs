module LDBench.Experiments.WideBaseline.Util where

import Control.Monad
import Text.Regex
import Text.RawString.QQ

import LDBench.Experiments.WideBaseline.Homography

readHomography :: FilePath -> IO Homography
readHomography filePath = do
  lines' <- liftM lines $ readFile filePath
  let
    floatingPointRegex = mkRegex [r|([-+]?[0-9]*\.?[0-9]+.)|]
  undefined
