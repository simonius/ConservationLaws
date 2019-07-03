// This project is licensed under the terms of the Creative Commons CC BY-NC-ND 4.0 license.

//--------------------------------------------------------------------------------------------------
// Functions for field initialisation
//--------------------------------------------------------------------------------------------------


// Example for inhomogeneous magnetic fields
// A dipole outside of the domain
// paramters
REAL4 constant M = {0.0, 0.0, 100.0, 0.0};
REAL4 constant X_0 = {-5.0, 0.5, 0.5, 0.0};
REAL constant A0 = 0.1;
REAL constant omega = 6.28 * 2;
REAL constant delta = 10;
REAL4 constant X_ex = {1.0, 0.5, 0.5, 0.0};
/*
There is no analytical solution for this simulation
*/
inline REAL4 u_analytical(uint ix, uint iy, uint iz, REAL time) {

  return (REAL4) {(REAL)(0), (REAL)(0), (REAL)(0), (REAL)(0)};
}

inline REAL4 b_analytical(uint ix, uint iy, uint iz, REAL time) {

  return (REAL4) {(REAL)(0), (REAL)(0), (REAL)(0), (REAL)(0)};
}

// Magnetic Dipole definition out of
// Course of Theoretical Physics: The Classical Theory of Fields
// L.D. Landau and E. M. Lifschitz
// (1951)

inline REAL4 b_dipole(REAL4 X, REAL4 M) {
  REAL inorm = rsqrt(X.x*X.x + X.y*X.y + X.z*X.z);
  REAL4 n = inorm * X;
  REAL4 H = (3 * n * dot(M, n) - M) * inorm * inorm * inorm;
  return H;
}

/* initial values for p, rho, B and the velocity */

inline REAL p_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL)(1.0);
}

inline REAL rho_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL)(1.0);
}



inline REAL4 b_initial(uint ix, uint iy, uint iz, REAL time){
  REAL x = XMIN + ix * DX - X_0.x;
  REAL y = YMIN + iy * DY - X_0.y;
  REAL z = ZMIN + iz * DZ - X_0.z;

  return b_dipole((REAL4){x, y, z, 0}, M);
}

inline REAL4 u_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL4){0, 0, 0, 0} ;
}


/*
Boundary condition of the magnetic field.
A sinusodial excitation of the magnetic field at X_xe and a gaussian radial profile
*/
inline REAL4 b_boundary(uint ix, uint iy, uint iz, REAL time) {
  REAL4 Pos;
  Pos.x = XMIN + ix * DX;
  Pos.y = YMIN + iy * DY;
  Pos.z = ZMIN + iz * DZ;
  REAL amplitude;
  REAL4 init_b = b_initial(ix, iy, iz, (REAL)0.0);
  if (Pos.x > 0.95) {
    amplitude = 1 + A0 * sin(omega*time) * exp(- delta * dot(X_ex-Pos, X_ex-Pos));
  }
  else {
    amplitude = 1;
  }

  return init_b * amplitude;
}

/*
Boundary condition of the velocity field.
*/
inline REAL4 u_boundary(uint ix, uint iy, uint iz, REAL time) {

  return u_initial(ix, iy, iz, time);
}

inline REAL rho_boundary(uint ix, uint iy, uint iz, REAL time) {

  return rho_initial(ix, iy, iz, time);
}

inline REAL p_boundary(uint ix, uint iy, uint iz, REAL time){

  return p_initial(ix, iy, iz, time);

}
