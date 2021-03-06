from math import pi

import numpy as np

from ogrid.rawGrid import RawGrid

O = RawGrid(0.1, 20, 15, 0.5)
print(len(O.bearing_ref))
step = np.array([4, 8, 16, 32])*O.GRAD2RAD

step = step[2]
theta = np.linspace(-pi/2, pi/2, pi/step)
a = 1
for i in range(0, len(theta)):
    O.updateCells(O.sonarConeLookup(step, theta[i]), a)
    if a == 1:
        a = 0.5
    else:
        a = 1
O.show()