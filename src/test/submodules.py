import unittest
import sub.f


class SubModulesTests(unittest.TestCase):
    def test_can_call_function_from_modules(self):
        actual = sub.f.simple_plus(2, 3)
        self.assertEqual(actual, 5)
