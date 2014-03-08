module LDBench.Detector where

import Data.Vector (Vector)

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.OpenCVComputation
import LDBench.Image


{-type Foo a = forall p t. Client p t -> IO a-}

{-newtype OpenCVComputation a = OpenCVComputation -}
  {-{ runOpenCVComputation :: Foo a-}
  {-}-}

{-instance Monad OpenCVComputation where-}
  {-OpenCVComputation x >>= f = f x-}
  {-return x = OpenCVComputation x-}

{-instance Monad OpenCVComputation where-}
  {-OpenCVComputation value >>= f = f value-}
  {-return a = OpenCVComputation a-}

    {-newtype Writer w a = Writer { runWriter :: (a, w) }  -}

class Detector a where
  detect :: a -> Image -> OpenCVComputation (Vector KeyPoint)
