module LDBench.Experiments.WideBaseline.Experiment where

import OpenCVThrift.OpenCV

import LDBench.Experiments.RuntimeConfig
import LDBench.Experiments.WideBaseline.Results

class Experiment e where
  runExperiment :: e -> RuntimeConfig -> OpenCVComputation Results
