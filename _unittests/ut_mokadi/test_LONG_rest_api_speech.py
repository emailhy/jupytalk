# -*- coding: utf-8 -*-
"""
@brief      test log(time=10s)
"""

import sys
import os
import unittest
import warnings


try:
    import src
except ImportError:
    path = os.path.normpath(
        os.path.abspath(
            os.path.join(
                os.path.split(__file__)[0],
                "..",
                "..")))
    if path not in sys.path:
        sys.path.append(path)
    import src

try:
    import pyquickhelper as skip_
except ImportError:
    path = os.path.normpath(
        os.path.abspath(
            os.path.join(
                os.path.split(__file__)[0],
                "..",
                "..",
                "..",
                "pyquickhelper",
                "src")))
    if path not in sys.path:
        sys.path.append(path)
    import pyquickhelper as skip_

from pyquickhelper.loghelper import fLOG
from pyquickhelper.pycode import is_travis_or_appveyor, add_missing_development_version


class TestLONGRestApiSpeech(unittest.TestCase):

    def setUp(self):
        add_missing_development_version(["jyquickhelper", "ensae_teaching_cs", "pymmails"],
                                        __file__, hide=True)

    def test_api_speech_reco(self):
        fLOG(
            __file__,
            self._testMethodName,
            OutputPrint=__name__ == "__main__")

        if is_travis_or_appveyor():
            # no keys
            return

        if os.environ.get("COMPUTERNAME", os.environ.get("HOSTNAME")).startswith("VSWINDOUZE"):
            # jenkins remote machine: no audio
            return

        # key must be renewed before calling it again
        return

        from src.jupytalk.mokadi.cognitive_services_helper import call_api_speech_reco
        with warnings.catch_warnings():
            warnings.simplefilter('ignore', DeprecationWarning)
            import keyring
        subkey = keyring.get_password(
            "cogser", os.environ["COMPUTERNAME"] + "voicereco")

        wav = os.path.join(os.path.abspath(
            os.path.dirname(__file__)), "data", "output.wav")
        with open(wav, "rb") as f:
            content = f.read()

        res = call_api_speech_reco(subkey, memwav=content)
        fLOG(res)
        self.assertTrue(isinstance(res, dict))
        for k, v in res.items():
            fLOG(k, v)
            if "results" == k:
                for _ in v:
                    fLOG(_)

        # returns something like
        # {'header': {'properties': {'requestid': '88af3c3f-3288-49f8-9dc3-4e0a30c9e97e', 'HIGHCONF': '1'},
        #                            'status': 'success',
        #                            'lexical': 'leocadie va chercher email',
        #                            'name': 'Leocadie va chercher email.', 'scenario': 'smd'},
        # 'results': [{'properties': {'HIGHCONF': '1'}, 'confidence': '0.6540837',
        #              'lexical': 'leocadie va chercher email',
        #              'name': 'Leocadie va chercher email.', 'scenario': 'smd'}],
        # 'version': '3.0'}


if __name__ == "__main__":
    unittest.main()
