module LDBench.Extractors.OpenCV where

import qualified Data.Vector
import qualified Data.Text.Lazy
import Data.Bits.Lens
import Control.Exception
import Data.Word
import Control.Lens
import Data.Array.Repa hiding (map, extract)
import Data.Maybe

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core
import OpenCVThrift.OpenCV.Core.MatUtil
import qualified OpenCVThrift.OpenCV.Features2D.Features2D
import OpenCVThrift.OpenCV.Features2D

import LDBench.Extractor
import LDBench.Convert
import LDBench.Extractors.Convert

data BRISK = BRISK

toRepa :: Mat -> OpenCVComputation (Array U DIM3 Double)
toRepa mat = do
  matUnpacked <- convert1 unpack mat 
  let
    rows = fromIntegral $ fromJust $ f_MatUnpacked_rows matUnpacked
    cols = fromIntegral $ fromJust $ f_MatUnpacked_cols matUnpacked
    channels = fromIntegral $ fromJust $ f_MatUnpacked_channels matUnpacked
    data' = Data.Vector.toList $ fromJust $ f_MatUnpacked_data matUnpacked
  return $ fromListUnboxed (Z :. rows :. cols :. channels) data'

meld :: [[Double]] -> [Bool] -> [Maybe [Double]]
meld rows mask = 
  assert (length rows == length (filter id mask)) $
  case (rows, mask) of
    ([], []) -> []
    ([], _ : maskTail) -> Nothing : meld [] maskTail
    (rowsHead : rowsTail, maskHead : maskTail) ->
      if maskHead == False
        then Nothing : meld rows maskTail
        else Just rowsHead : meld rowsTail maskTail
    _ -> error "This should not happen." 

fromExtractorResponse :: ExtractorResponse -> OpenCVComputation [Maybe [Double]]
fromExtractorResponse 
  (ExtractorResponse (Just descriptorMat) (Just keyPointMask)) = do
     descriptorRepa <- toRepa descriptorMat
     let
       getRow :: Int -> [Double]
       getRow i = toList $ slice descriptorRepa (Z :. i :. All :. (0 :: Int)) 
       [numRows, _, numChannels] = listOfShape $ extent descriptorRepa 
       rows = map getRow [0 .. numRows - 1]
     return $ 
       assert (numChannels == 0) $ 
       meld rows (Data.Vector.toList keyPointMask) 

doubleToBitstring :: Double -> [Bool]
doubleToBitstring double =
  assert (double >= 0) $
  assert (double < 256) $
  let rounded = round double :: Word8 in
  assert (fromIntegral rounded == double) $
  [ rounded ^. bitAt 0
  , rounded ^. bitAt 1 
  , rounded ^. bitAt 2 
  , rounded ^. bitAt 3 
  , rounded ^. bitAt 4 
  , rounded ^. bitAt 5 
  , rounded ^. bitAt 6 
  , rounded ^. bitAt 7 
  ]

instance Extractor BRISK [Bool] where
  extract BRISK image keyPoints = do
    imageMat <- imageToMat image
    extractorResponse <- convert3 
      OpenCVThrift.OpenCV.Features2D.Features2D.extract 
      (Data.Text.Lazy.pack "BRISK")
      imageMat
      (Data.Vector.fromList keyPoints)
    descriptorsAsDoubles <- fromExtractorResponse extractorResponse
    return $ map (fmap (concatMap doubleToBitstring)) descriptorsAsDoubles

  extractSingle BRISK = extractToExtractSingle $ extract BRISK

