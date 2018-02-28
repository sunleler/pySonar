from scipy.spatial import Voronoi
import numpy as np

class MyVoronoi(Voronoi):
    def __init__(self, points):
        super(MyVoronoi, self).__init__(points)

    def add_wp(self, point_index):
        if point_index < 0:
            region_index = self.point_region[np.shape(self.points)[0] + point_index]
        else:
            region_index = self.point_region[point_index]

        self.vertices = np.append(self.vertices, [self.points[point_index]], axis=0)
        new_vertice = np.shape(self.vertices)[0]-1

        for i in range(np.shape(self.regions[region_index])[0]):
            self.ridge_vertices.append([int(new_vertice), int(self.regions[region_index][i])])
