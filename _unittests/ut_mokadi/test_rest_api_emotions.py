#-*- coding: utf-8 -*-
"""
@brief      test log(time=5s)
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
from pyquickhelper.pycode import is_travis_or_appveyor
from src.jupytalk.mokadi.cognitive_services_helper import call_api_emotions


class TestRestApiEmotions(unittest.TestCase):

    def test_api_emotions(self):
        fLOG(
            __file__,
            self._testMethodName,
            OutputPrint=__name__ == "__main__")

        if is_travis_or_appveyor():
            # no keys
            return

        path = os.path.join(os.path.abspath(os.path.dirname(__file__)), "data")
        imgs = [os.path.join(path, "84-cate-blanchett-jude-quinn-i-m-not-there-2007--630-75.jpg"),
                os.path.join(path, "Cate_Blanchett_Deauville_2013_2.jpg")]

        with warnings.catch_warnings():
            warnings.simplefilter('ignore', DeprecationWarning)
            import keyring
        subkey = keyring.get_password(
            "cogser", os.environ["COMPUTERNAME"] + "emotions")
        for img in imgs:
            res = call_api_emotions(subkey, img)
            if isinstance(res, dict) and "error" in res:
                warnings.warn("Key should be checked or renewed.")
                continue
            if not isinstance(res, list):
                raise TypeError(type(res))
            self.assertTrue(len(img) > 0)
            for _ in res:
                fLOG(_)


if __name__ == "__main__":
    unittest.main()
