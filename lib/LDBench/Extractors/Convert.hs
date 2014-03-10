module LDBench.Extractors.Convert where

import Control.Monad

import LDBench.Extractor

extractToExtractSingle :: Extract f -> ExtractSingle f
extractToExtractSingle extract' = 
  \image keyPoint -> liftM head $ extract' image [keyPoint]
