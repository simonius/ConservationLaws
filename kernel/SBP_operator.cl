//This project is licensed under the terms of the Creative Commons CC BY-NC-ND 4.0 license.

// Contains a number of differential operators for scalar and vector type fields (inline functions)

#ifdef USE_PERIODIC_X
    #define STENCIL_WIDTH_X STENCIL_WIDTH_P
    #define SBP_diff_X SBP_diff_P
    #define NUM_BOUNDS_X NUM_BOUNDS_P
    #define M_INV_X M_INV_P
#else
    #define STENCIL_WIDTH_X STENCIL_WIDTH_B
    #define SBP_diff_X SBP_diff_B
    #define NUM_BOUNDS_X NUM_BOUNDS_B
    #define M_INV_X M_INV_B
#endif

#ifdef USE_PERIODIC_Y
    #define STENCIL_WIDTH_Y STENCIL_WIDTH_P
    #define SBP_diff_Y  SBP_diff_P
    #define NUM_BOUNDS_Y NUM_BOUNDS_P
    #define M_INV_Y M_INV_P
#else
    #define STENCIL_WIDTH_Y STENCIL_WIDTH_B
    #define SBP_diff_Y  SBP_diff_B
    #define NUM_BOUNDS_Y NUM_BOUNDS_B
    #define M_INV_Y M_INV_B
#endif

#ifdef USE_PERIODIC_Z
    #define STENCIL_WIDTH_Z STENCIL_WIDTH_P
    #define SBP_diff_Z SBP_diff_P
    #define NUM_BOUNDS_Z NUM_BOUNDS_P
    #define M_INV_Z M_INV_P
#else
    #define STENCIL_WIDTH_Z STENCIL_WIDTH_B
    #define SBP_diff_Z  SBP_diff_B
    #define NUM_BOUNDS_Z NUM_BOUNDS_B
    #define M_INV_Z M_INV_B
#endif


//--------------------------------------------------------------------------------------------------
// Operator for vector fields
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
// Derivatives for vector fields
// Computes the derivative in x-direction of the vector field `d_field` at point (ix,iy,iz)
inline REAL4 diff_x(uint ix, uint iy, uint iz, global REAL *u, uint comp) {

	REAL4 val = (REAL4) {0, 0, 0, 0};

  REAL field[NUM_TOTAL_VARS] = {0.0};

	int bound_x = get_bound_x(ix, NUM_BOUNDS_X);

  for (uint i = 0; i < STENCIL_WIDTH_X; i++) {
    get_field(ix,iy,iz,(i - (STENCIL_WIDTH_X - 1)/2),0,0,u, field);
    val.x = val.x + SBP_diff_X[NUM_BOUNDS_X + bound_x][i]*field[comp];
    val.y = val.y + SBP_diff_X[NUM_BOUNDS_X + bound_x][i]*field[comp + 1];
    val.z = val.z + SBP_diff_X[NUM_BOUNDS_X + bound_x][i]*field[comp + 2];
  }

	return val / ((REAL)DX);
}

// Computes the derivative in y-direction of the vector field `d_field` at point (ix,iy,iz)
inline REAL4 diff_y(uint ix, uint iy, uint iz, global REAL *u, uint comp) {

	REAL4 val = (REAL4) {0, 0, 0, 0};

  REAL field[NUM_TOTAL_VARS] = {0.0};

	int bound_y = get_bound_y(iy, NUM_BOUNDS_Y);

  for (uint i = 0; i < STENCIL_WIDTH_Y; i++) {
    get_field(ix,iy,iz,0,(i - (STENCIL_WIDTH_Y - 1)/2),0,u, field);
    val.x = val.x + SBP_diff_Y[NUM_BOUNDS_Y + bound_y][i]*field[comp];
    val.y = val.y + SBP_diff_Y[NUM_BOUNDS_Y + bound_y][i]*field[comp + 1];
    val.z = val.z + SBP_diff_Y[NUM_BOUNDS_Y + bound_y][i]*field[comp + 2];
  }

	return val / ((REAL)DY);
}

// Computes the derivative in z-direction of the vector field `d_field` at point (ix,iy,iz)
inline REAL4 diff_z(uint ix, uint iy, uint iz, global REAL *u, uint comp) {

	REAL4 val = (REAL4) {0, 0, 0, 0};

  REAL field[NUM_TOTAL_VARS] = {0.0};

	int bound_z = get_bound_z(iz, NUM_BOUNDS_Z);

  for (uint i = 0; i < STENCIL_WIDTH_Z; i++) {
    get_field(ix,iy,iz,0,0,(i - (STENCIL_WIDTH_Z - 1)/2),u, field);
    val.x = val.x + SBP_diff_Z[NUM_BOUNDS_Z + bound_z][i]*field[comp];
    val.y = val.y + SBP_diff_Z[NUM_BOUNDS_Z + bound_z][i]*field[comp + 1];
    val.z = val.z + SBP_diff_Z[NUM_BOUNDS_Z + bound_z][i]*field[comp + 2];
  }

	return val / ((REAL)DZ);
}


//--------------------------------------------------------------------------------------------------
// Computes the curl of vector field `d_field` at point (ix,iy,iz)
inline REAL4 curl(uint ix, uint iy, uint iz, global REAL *u, uint comp) {

  REAL4 val = (REAL4) {0, 0, 0, 0};

  val.x = diff_y(ix, iy, iz, u, comp).z - diff_z(ix, iy, iz, u, comp).y;
  val.y = diff_z(ix, iy, iz, u, comp).x - diff_x(ix, iy, iz, u, comp).z;
  val.z = diff_x(ix, iy, iz, u, comp).y - diff_y(ix, iy, iz, u, comp).x;

  return val;
}
