
import os, sys

print(sys.argv)

class Object:

    def __init__(self, V):
        self.val = V
        self.slot = {}
        self.nest = []

    def __repr__(self): return self.dump()

    def dump(self, depth=0, prefix=''):
        tree = self.pad(depth) + self.head(prefix)
        for i in self.slot:
            tree += self.slot[i].dump(depth + 1, prefix='%s = ' % i)
        for j in self.nest:
            tree += j.dump(depth + 1)
        return tree

    def head(self, prefix=''):
        return '%s<%s:%s> @%x' % (prefix, self._type(), self._val(), id(self))

    def pad(self, depth): return '\n' + '\t' * depth

    def _type(self): return self.__class__.__name__.lower()
    def _val(self): return '%s' % self.val

    def __floordiv__(self, that):
        self.nest.append(that)
        return self


hello = Object('hello')
world = Object('world')

print(hello // world)
