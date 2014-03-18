module LDBench.Experiments.WideBaseline.Util where

import Control.Monad
import Text.Regex
import Text.RawString.QQ
import Data.List.Split
import Data.Array.Repa hiding (map, (++))

import LDBench.Experiments.WideBaseline.Homography

readHomography :: FilePath -> IO Homography
readHomography filePath = do
  contents <- readFile filePath
  let 
    words' = words contents
    fixParse :: String -> String
    fixParse word =
      if last word == '.'
        then word ++ "0"
        else word
    fixed = map fixParse words'
    doubles = map (read :: String -> Double) fixed 
    data' = fromListUnboxed (Z :. (3 :: Int) :. (3 :: Int)) doubles
  putStrLn $ show $ Homography data'
  return $ Homography data' 
