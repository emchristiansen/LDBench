module LDBench.Experiments.WideBaseline.Homography where

import Data.Maybe

import OpenCVThrift.OpenCV.Core
import Control.Exception
import Control.Lens hiding (index)
import Data.Array.Repa hiding ((++))
import Data.Array.Repa.Algorithms.Matrix

import LDBench.ImageBijection

declareFields [d|
  data Homography = Homography
    { _data :: Array U DIM2 Double
    } deriving (Show)
  |]

toHomogeneous :: Array U DIM2 Double -> Array U DIM2 Double
toHomogeneous vector =
  let
    [rows, cols] = listOfShape $ extent vector
  in
    assert (rows == 2) $
    assert (cols == 1) $
    fromListUnboxed (Z :. 3 :. 1) $ toList vector ++ [1]

fromHomogeneous :: Array U DIM2 Double -> Array U DIM2 Double
fromHomogeneous vector =
  let
    [rows, cols] = listOfShape $ extent vector
  in
    assert (rows == 3) $
    assert (cols == 1) $
    fromListUnboxed (Z :. 2 :. 1) $ init $ toList vector

instance ImageBijection Homography where
  leftToRight 
    (Homography data') 
    (KeyPoint
      pt
      size
      angle
      response
      octave
      class_id) = 
    let
      source = fromListUnboxed 
        (Z :. (2 :: Int) :. (1 :: Int)) 
        [ fromJust . f_Point2d_x . fromJust $ pt 
        , fromJust . f_Point2d_y . fromJust $ pt ]
      sourceH = toHomogeneous source
      destinationH = mmultS data' sourceH
      destination = fromHomogeneous destinationH 
      point = Point2d
        (Just $ index destination (Z :. 0 :. 0))
        (Just $ index destination (Z :. 1 :. 0))
    in
      KeyPoint 
        (Just point)
        size
        angle
        response
        octave
        class_id
        
         
