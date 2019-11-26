module Test.Main where

import Aff
import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), launchAff_)
import Effect.Class.Console (log)
import Test.Spec (Spec, describe, it, sequential)
import Test.Spec.Assertions (fail)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec')

test :: Spec Unit
test = describe "sequential test" $ sequential do
  it "runs 0 thing" $ do
     log "start"

  it "runs 1 thing" $ do
     void $ run 3
     log "hi1"

  it "runs 2 things" $ do
     void $ run 2
     log "hi2"

main :: Effect Unit
main = launchAff_ $ runSpec' config [consoleReporter] test
  where
    config = { slow: Milliseconds 5000.0, timeout: Nothing, exit: false }
