import tempfile
import unittest
from pathlib import Path
from replay_signals import Signal, sample_index, DATA


class ReplayTests(unittest.TestCase):
    def table(self, rows):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'signal.txt'
            path.write_text(f'#1\ndouble test({len(rows)},2)\n' + '\n'.join(rows))
            return Signal.read(path)

    def test_interpolation_and_duplicate_removal(self):
        signal = self.table(['0 0', '0.06 6', '0.06 6', '0.1 2'])
        self.assertEqual(len(signal.times), 3)
        self.assertAlmostEqual(signal.at(0.02), 2)
        self.assertAlmostEqual(signal.at(0.08), 4)
        self.assertEqual(signal.at(0.02, 'hold'), 0)
        self.assertEqual(signal.at(1), 2)

    def test_invalid_tables(self):
        for rows in (['0 0', '0 1'], ['0 0', '1 nan'], ['0 0', '1 1e40'],
                     ['0 0', '1 1', '0.5 2'], ['1 0', '2 2']):
            with self.subTest(rows=rows), self.assertRaises(ValueError):
                self.table(rows)

    def test_late_slots_are_skipped(self):
        self.assertEqual(sample_index(85_000_000, 1), 4)
        self.assertEqual(sample_index(20_000_000, 0), 1)

    def test_supplied_files(self):
        a = Signal.read(DATA / 'propellerFeedback.txt')
        b = Signal.read(DATA / 'rudderFeedback.txt')
        self.assertEqual(a.times[-1], 163.059113)
        self.assertEqual(a.times, b.times)
        self.assertEqual(a.at(0), 0)
        self.assertAlmostEqual(a.at(0.02), 3.4644712577133321 / 3)


if __name__ == '__main__':
    unittest.main()
