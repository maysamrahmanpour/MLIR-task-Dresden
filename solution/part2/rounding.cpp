#include <cstdio>
int main(void) {
  // Volatile prevents constant-folding of the complete comparison at O0.
  volatile double x=9.0, divisor=9.0;
  double divided=x/divisor;
  double reciprocal=1.0/divisor;
  double multiplied=x*reciprocal;
  std::printf("x=9: x/9=%a, x*(1/9)=%a\n",divided,multiplied);
  // Search reproducibly rather than assuming x=9 is a counterexample.
  for(int i=1;i<100000;++i) {
    x=static_cast<double>(i);
    divided=x/divisor;multiplied=x*reciprocal;
    if(divided!=multiplied) {
      std::printf("counterexample x=%d: division=%a reciprocal-multiply=%a\n",i,divided,multiplied);
      return 0;
    }
  }
  std::puts("No counterexample in this tested range; this does not prove equivalence.");
  return 0;
}
