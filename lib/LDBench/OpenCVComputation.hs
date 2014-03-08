module LDBench.OpenCVComputation where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

-- TODO: Make this a monad and move to OpenCVThrift.
newtype OpenCVComputation a = OpenCVComputation 
  { runOpenCVComputation :: forall p t. Client p t -> IO a 
  }
