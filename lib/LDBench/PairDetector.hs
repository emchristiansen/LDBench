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

class PairDetector d where
  detectPairs :: 
    ImageBijection b => 
      d -> 
      b -> 
      Image -> 
      Image -> 
      OpenCVComputation [(KeyPoint, KeyPoint)]

l2Distance :: Point2d -> Point2d -> Double
l2Distance = undefined

nearestUnderBijection :: 
  Double -> (Point2d -> Point2d) -> Point2d -> [Point2d] -> Maybe Point2d
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
    Double -> d -> [Point2d] -> [Point2d] -> [(Point2d, Point2d)]
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
    let 
      points image = 
        liftM (map (fromJust . f_KeyPoint_pt)) $ detect detector image
    point0s <- points image0
    point1s <- points image1
    return $ do
      (point0', point1') <- bijectiveMatches 
        threshold 
        bijection 
        point0s
        point1s
      let
        mkKeyPoint point = KeyPoint
          (Just point)
          (Just 0)
          (Just 0)
          (Just 0)
          (Just 0)
          (Just 0)
      return $ (mkKeyPoint point0', mkKeyPoint point1')
