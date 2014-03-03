module LDBench.Image where

{-import System.Directory-}
{-import System.FilePath.Posix-}
{-import Data.Char-}
--import Control.Exception
--import System.IO.Error
{-import qualified Codec.Picture as CP-}
import Codec.Picture (PixelRGBA8, imageWidth, imageHeight, imageData)
import qualified Codec.Picture as CP
{-import qualified Codec.Picture.Types as CPT-}
{-import Text.Printf-}
import Control.Arrow ((&&&))
--import Data.ByteString.Lazy (toStrict)
--import System.IO
--import Control.Concurrent (threadDelay)
--import System.Random
import Data.Word (Word8)
import Data.Vector.Storable (Vector)

type Image = CP.Image PixelRGBA8

instance Show Image where
  show image = show $ (imageWidth image, imageHeight image)

_properties :: Image -> (Int, (Int, Vector Word8))
_properties = imageWidth &&& imageHeight &&& imageData

-- TODO: Surely I don't need this given I have defined Ord below.
instance Eq Image where
  left == right = _properties left == _properties right

instance Ord Image where
  left `compare` right = _properties left `compare` _properties right
