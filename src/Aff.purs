module Aff
  (runAff
  ) where

import Prelude

import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (log)
import Effect (Effect)
import Control.Promise (Promise, toAff)

-- Sleep for n seconds
foreign import delays :: Int -> Promise Unit
-- Throw i input is 1
foreign import dieIf1 :: Int -> Int

run :: Int -> Aff Int
run i = do
  _ <- do
    toAff $ delays i
    let x = dieIf1 i
    log $ "doing things: " <> show i
  pure $ i + 1

runAff :: Effect Unit
runAff = do
  launchAff_ $
    run 0
    >>= run
    >>= run
    >>= run
    >>= run
  launchAff_ $
    run 5
    >>= run
    >>= run
    >>= run
    >>= run

