// This project is licensed under the terms of the Creative Commons CC BY-NC-ND 4.0 license.

//--------------------------------------------------------------------------------------------------
// Functions for field initialisation
//--------------------------------------------------------------------------------------------------


// Example for homogeneous magnetic fields
REAL4 constant B0 = {0.0, 0.0, 0.5, 0.0};
REAL constant A0 = 0.1;
REAL constant omega = 6.28 * 10;
/*
There is no analytical solution for this simulation yet
*/
inline REAL4 u_analytical(uint ix, uint iy, uint iz, REAL time) {

  return (REAL4) {(REAL)(0), (REAL)(0), (REAL)(0), (REAL)(0)};
}

inline REAL4 b_analytical(uint ix, uint iy, uint iz, REAL time) {

  return (REAL4) {(REAL)(0), (REAL)(0), (REAL)(0), (REAL)(0)};
}

/* initial values for p, rho, B and the velocity */

inline REAL p_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL)(1.0);
}

inline REAL rho_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL)(1.0);
}



inline REAL4 b_initial(uint ix, uint iy, uint iz, REAL time){
  return B0;
}

inline REAL4 u_initial(uint ix, uint iy, uint iz, REAL time){

  return (REAL4){0, 0, 0, 0} ;
}


/*
Boundary condition of the magnetic field.
The absolute magnetic field of the right boundary in x-direction oscillates. 
We would like to see the waves which propagate to the left.
*/
inline REAL4 b_boundary(uint ix, uint iy, uint iz, REAL time) {
  REAL x = XMIN + ix * DX;
  REAL y = YMIN + iy * DY;
  REAL z = ZMIN + iz * DZ;
  REAL amplitude;
  REAL4 init_b = b_initial(ix, iy, iz, (REAL)0.0);
  if (x > 0.9) {
    amplitude = 1 + A0 * sin(omega*time) * (x - 0.9) * 10;
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
