module Generic
  (runGeneric
  ) where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Array (zipWith)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Eq (genericEq)
import Data.Generic.Rep.Show (genericShow)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Console (log)
import Foreign.Generic (class Decode, class Encode, Options, F, decode, defaultOptions, encode, genericDecode, genericEncode)
import System.Clock (nanoseconds)
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary, genericArbitrary)
import Test.QuickCheck.Gen (randomSample')

data MyData = MyData { b :: Boolean
                     , i :: Int
                     , n :: Number
                     , s :: String
                     }

derive instance genericMyData :: Generic MyData _
instance showMyData :: Show MyData where show = genericShow
instance eqMyData :: Eq MyData where eq = genericEq

options :: Options
options = defaultOptions { unwrapSingleConstructors = true }

instance decodeMyData :: Decode MyData where decode = genericDecode options
instance encodeMyData :: Encode MyData where encode = genericEncode options

instance arbitraryMyData :: Arbitrary MyData where arbitrary = genericArbitrary

numItems :: Int
numItems = 5000

items :: Effect (Array MyData)
items = randomSample' numItems arbitrary

runGeneric :: Effect Unit
runGeneric = do
  i <- items
  log "Starting"
  -- Use this for observing times on the console
  --e <- traverse (time encode) i
  --d <- traverse (time decode) e
  let e = encode <$> i
  let d = decode <$> e
  log "Done"
  let _ = zipWith checkItem i d
  pure unit
  where
        checkItem :: MyData -> F MyData -> Effect Unit
        checkItem a b =
          case runExcept b of
               Right b' -> when (a /= b') (log $ "mismatch: " <> show a <> ", " <> show b')
               Left err -> log $ "error: " <> show err

        time :: forall a b. String -> (a -> b) -> a -> Effect b
        time msg f v = do
           tick <- nanoseconds
           let ret = f v
           tock <- nanoseconds
           log $ msg <> ": " <> show (tock - tick)
           pure ret
