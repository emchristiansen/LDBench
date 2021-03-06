module LDBench.PairDetector where

import Control.Exception
import Data.List
import Data.Ord
import Data.Maybe
import Control.Monad

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.Image
import LDBench.Detector
import LDBench.ImageBijection
import LDBench.Util

class PairDetector d where
  detectPairs :: 
    ImageBijection b => 
      d -> 
      b -> 
      Image -> 
      Image -> 
      OpenCVComputation [(KeyPoint, KeyPoint)]

nearestUnderBijection :: 
  Double -> (KeyPoint -> KeyPoint) -> KeyPoint -> [KeyPoint] -> Maybe KeyPoint
nearestUnderBijection threshold bijection query points = 
  assert (length points > 0) $
  let
    query' = bijection query
    distanceToQuery point = l2Distance query' point
    nearest = minimumBy (comparing distanceToQuery) points
  in
    if distanceToQuery nearest <= threshold
      then Just nearest
      else Nothing

bijectiveMatches ::
  ImageBijection d =>
    Double -> d -> [KeyPoint] -> [KeyPoint] -> [(KeyPoint, KeyPoint)]
bijectiveMatches threshold bijection point0s point1s =
  assert (length point0s > 0) $
  assert (length point1s > 0) $
  do
    point0 <- point0s
    point1 <- maybeToList $ nearestUnderBijection 
      threshold 
      (leftToRight bijection)
      point0
      point1s
    point0' <- maybeToList $ nearestUnderBijection
      threshold
      (rightToLeft bijection)
      point1
      point0s
    if (point0 == point0')
      then [(point0, point1)]
      else []

instance (Detector d) => PairDetector (Double, d) where
  detectPairs (threshold, detector) bijection image0 image1 = do
    {-let -}
      {-points image = -}
        {-liftM (map (fromJust . f_KeyPoint_pt)) $ detect detector image-}
    point0s <- detect detector image0
    point1s <- detect detector image1
    let
      getResponse = fromJust . f_KeyPoint_response
      responseProduct (p0, p1) = (getResponse p0) * (getResponse p1)
    return $ reverse $ sortBy (comparing responseProduct) $ do
      (point0', point1') <- bijectiveMatches 
        threshold 
        bijection 
        point0s
        point1s
      {-let-}
        {-mkKeyPoint point = KeyPoint-}
          {-(Just point)-}
          {-(Just 0)-}
          {-(Just 0)-}
          {-(Just 0)-}
          {-(Just 0)-}
          {-(Just 0)-}
      {-return $ (mkKeyPoint point0', mkKeyPoint point1')-}
      return $ (point0', point1')
