module LDBench.Experiments.WideBaseline.Experiment where

import LDBench.Experiments.RuntimeConfig
import LDBench.Experiments.WideBaseline.Results

class Experiment e where
  run :: e -> RuntimeConfig -> Results
