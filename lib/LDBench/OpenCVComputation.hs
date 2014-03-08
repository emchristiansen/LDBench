module LDBench.OpenCVComputation where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import Thrift.Protocol.Binary
import GHC.IO.Handle.Types (Handle)

-- TODO: Make this a monad and move to OpenCVThrift.
newtype OpenCVComputation a = OpenCVComputation 
  { runOpenCVComputation :: forall p t. Client p t -> IO a 
  }

instance Monad OpenCVComputation where
  OpenCVComputation closure >>= f = OpenCVComputation $ \client -> do
    value <- closure client 
    let OpenCVComputation closure' = f value
    closure' client
  return x = OpenCVComputation $ \client -> return x

convert0 :: (forall p t. Client p t -> IO a) -> OpenCVComputation a
convert0 f = OpenCVComputation f

convert1 :: (forall p t. Client p t -> b1 -> IO a) -> b1 -> OpenCVComputation a
convert1 f arg1 = OpenCVComputation $ \client -> f client arg1

convert2 :: (forall p t. Client p t -> b1 -> b2 -> IO a) -> b1 -> b2 -> OpenCVComputation a
convert2 f arg1 arg2 = OpenCVComputation $ \client -> f client arg1 arg2

type ClientLocalhost = OpenCVThrift.OpenCV.Client BinaryProtocol Handle

data Blah a = Blah (ClientLocalhost -> IO a)

{-do-}
  {-mat <- pack matUnpacked-}
  {-keyPoints <- detect mat-}

{-pack :: Client -> MatUnpacked -> IO Mat-}
{-detect :: Client -> Mat -> IO [KeyPoint]-}

{-f :: (ClientLocalhost -> IO a) -}
{-f :: a -}
{-k-}

instance Monad Blah where
  Blah x >>= f = Blah $ \client -> do
    value <- x client 
    let Blah x' = f value
    x' client
  return x = Blah $ \client -> return x

