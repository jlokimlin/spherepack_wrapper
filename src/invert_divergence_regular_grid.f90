!
!     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!     *                                                               *
!     *                  copyright (c) 1998 by UCAR                   *
!     *                                                               *
!     *       University Corporation for Atmospheric Research         *
!     *                                                               *
!     *                      all rights reserved                      *
!     *                                                               *
!     *                         Spherepack                            *
!     *                                                               *
!     *       A Package of Fortran Subroutines and Programs           *
!     *                                                               *
!     *              for Modeling Geophysical Processes               *
!     *                                                               *
!     *                             by                                *
!     *                                                               *
!     *                  John Adams and Paul Swarztrauber             *
!     *                                                               *
!     *                             of                                *
!     *                                                               *
!     *         the National Center for Atmospheric Research          *
!     *                                                               *
!     *                Boulder, Colorado  (80307)  U.S.A.             *
!     *                                                               *
!     *                   which is sponsored by                       *
!     *                                                               *
!     *              the National Science Foundation                  *
!     *                                                               *
!     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!
submodule(divergence_routines) invert_divergence_regular_grid

contains

    !     subroutine idivec(nlat, nlon, isym, nt, v, w, idvw, jdvw, a, b, mdab, ndab, &
    !                       wvhsec, pertrb, ierror)
    !
    !     given the scalar spherical harmonic coefficients a and b, precomputed
    !     by subroutine shaec for a scalar array dv, subroutine idivec computes
    !     an irrotational vector field (v, w) whose divergence is dv - pertrb.
    !     w is the east longitude component and v is the colatitudinal component.
    !     pertrb is a constant which must be subtracted from dv for (v, w) to
    !     exist (see the description of pertrb below).  usually pertrb is zero
    !     or small relative to dv.  the vorticity of (v, w), as computed by
    !     vortec, is the zero scalar field.  v(i, j) and w(i, j) are the
    !     velocity components at colatitude
    !
    !            theta(i) = (i-1)*pi/(nlat-1)
    !
    !     and longitude
    !
    !            lambda(j) = (j-1)*2*pi/nlon.
    !
    !     the
    !
    !            divergence[v(i, j), w(i, j)]
    !
    !          = [d(w(i, j)/dlambda + d(sint*v(i, j))/dtheta]/sint
    !
    !          = dv(i, j) - pertrb
    !
    !     and
    !
    !            vorticity(v(i, j), w(i, j))
    !
    !         =  [dv/dlambda - d(sint*w)/dtheta]/sint
    !
    !         =  0.0
    !
    !     where sint = sin(theta(i)).  required associated legendre polynomials
    !     are recomputed rather than stored as they are in subroutine idives.
    !
    !     input parameters
    !
    !
    !     nlat   the number of colatitudes on the full sphere including the
    !            poles. for example, nlat = 37 for a five degree grid.
    !            nlat determines the grid increment in colatitude as
    !            pi/(nlat-1).  if nlat is odd the equator is located at
    !            grid point i=(nlat + 1)/2. if nlat is even the equator is
    !            located half way between points i=nlat/2 and i=nlat/2+1.
    !            nlat must be at least 3. note: on the half sphere, the
    !            number of grid points in the colatitudinal direction is
    !            nlat/2 if nlat is even or (nlat + 1)/2 if nlat is odd.
    !
    !     nlon   the number of distinct londitude points.  nlon determines
    !            the grid increment in longitude as 2*pi/nlon. for example
    !            nlon = 72 for a five degree grid. nlon must be greater than
    !            3.  the efficiency of the computation is improved when nlon
    !            is a product of small prime numbers.
    !
    !
    !     isym   this has the same value as the isym that was input to
    !            subroutine shaec to compute the arrays a and b from the
    !            scalar field dv.  isym determines whether (v, w) are
    !            computed on the full or half sphere as follows:
    !
    !      = 0
    !
    !           dv is not symmetric about the equator. in this case
    !           the vector field (v, w) is computed on the entire sphere.
    !           i.e., in the arrays  v(i, j), w(i, j) for i=1, ..., nlat and
    !           j=1, ..., nlon.
    !
    !      = 1
    !
    !           dv is antisymmetric about the equator. in this case w is
    !           antisymmetric and v is symmetric about the equator. w
    !           and v are computed on the northern hemisphere only.  i.e.,
    !           if nlat is odd they are computed for i=1, ..., (nlat + 1)/2
    !           and j=1, ..., nlon.  if nlat is even they are computed for
    !           i=1, ..., nlat/2 and j=1, ..., nlon.
    !
    !      = 2
    !
    !           dv is symmetric about the equator. in this case w is
    !           symmetric and v is antisymmetric about the equator. w
    !           and v are computed on the northern hemisphere only.  i.e.,
    !           if nlat is odd they are computed for i=1, ..., (nlat + 1)/2
    !           and j=1, ..., nlon.  if nlat is even they are computed for
    !           i=1, ..., nlat/2 and j=1, ..., nlon.
    !
    !
    !     nt     nt is the number of divergence and vector fields.  some
    !            computational efficiency is obtained for multiple fields.
    !            the arrays a, b, v, and w can be three dimensional and pertrb
    !            can be one dimensional corresponding to an indexed multiple
    !            array dv.  in this case, multiple vector synthesis will be
    !            performed to compute each vector field.  the third index for
    !            a, b, v, w and first for pertrb is the synthesis index which
    !            assumes the values k = 1, ..., nt.  for a single synthesis set
    !            nt = 1.  the description of the remaining parameters is
    !            simplified by assuming that nt=1 or that a, b, v, w are two
    !            dimensional and pertrb is a constant.
    !
    !     idvw   the first dimension of the arrays v, w as it appears in
    !            the program that calls idivec. if isym = 0 then idvw
    !            must be at least nlat.  if isym = 1 or 2 and nlat is
    !            even then idvw must be at least nlat/2. if isym = 1 or 2
    !            and nlat is odd then idvw must be at least (nlat + 1)/2.
    !
    !     jdvw   the second dimension of the arrays v, w as it appears in
    !            the program that calls idivec. jdvw must be at least nlon.
    !
    !     a, b    two or three dimensional arrays (see input parameter nt)
    !            that contain scalar spherical harmonic coefficients
    !            of the divergence array dv as computed by subroutine shaec.
    !     ***    a, b must be computed by shaec prior to calling idivec.
    !
    !     mdab   the first dimension of the arrays a and b as it appears in
    !            the program that calls idivec (and shaec). mdab must be at
    !            least min(nlat, (nlon+2)/2) if nlon is even or at least
    !            min(nlat, (nlon + 1)/2) if nlon is odd.
    !
    !     ndab   the second dimension of the arrays a and b as it appears in
    !            the program that calls idivec (and shaec). ndab must be at
    !            least nlat.
    !
    !
    !  wvhsec    an array which must be initialized by subroutine vhseci.
    !            once initialized,
    !            wvhsec can be used repeatedly by idivec as long as nlon
    !            and nlat remain unchanged.  wvhsec must not be altered
    !            between calls of idivec.
    !
    !
    !  lvhsec    the dimension of the array wvhsec as it appears in the
    !            program that calls idivec. define
    !
    !               l1 = min(nlat, nlon/2) if nlon is even or
    !               l1 = min(nlat, (nlon + 1)/2) if nlon is odd
    !
    !            and
    !
    !               l2 = nlat/2        if nlat is even or
    !               l2 = (nlat + 1)/2    if nlat is odd
    !
    !            then lvhsec must be at least
    !
    !            4*nlat*l2+3*max(l1-2, 0)*(2*nlat-l1-1)+nlon+15
    !
    !     output parameters
    !
    !
    !     v, w   two or three dimensional arrays (see input parameter nt) that
    !           contain an irrotational vector field whose divergence is
    !           dv-pertrb at the colatitude point theta(i)=(i-1)*pi/(nlat-1)
    !           and longitude point lambda(j)=(j-1)*2*pi/nlon.  w is the east
    !           longitude component and v is the colatitudinal component.  the
    !           indices for w and v are defined at the input parameter isym.
    !           the curl or vorticity of (v, w) is the zero vector field.  note
    !           that any nonzero vector field on the sphere will be multiple
    !           valued at the poles [reference swarztrauber].
    !
    !   pertrb  a nt dimensional array (see input parameter nt and assume nt=1
    !           for the description that follows).  dv - pertrb is a scalar
    !           field which can be the divergence of a vector field (v, w).
    !           pertrb is related to the scalar harmonic coefficients a, b
    !           of dv (computed by shaec) by the formula
    !
    !                pertrb = a(1, 1)/(2.*sqrt(2.))
    !
    !
    !
    !           the unperturbed scalar field dv can be the divergence of a
    !           vector field only if a(1, 1) is zero.  if a(1, 1) is nonzero
    !           (flagged by pertrb nonzero) then subtracting pertrb from
    !           dv yields a scalar field for which a(1, 1) is zero.
    !
    !    ierror = 0  no errors
    !           = 1  error in the specification of nlat
    !           = 2  error in the specification of nlon
    !           = 3  error in the specification of isym
    !           = 4  error in the specification of nt
    !           = 5  error in the specification of idvw
    !           = 6  error in the specification of jdvw
    !           = 7  error in the specification of mdab
    !           = 8  error in the specification of ndab
    !           = 9  error in the specification of lvhsec
    !
    module subroutine idivec(nlat, nlon, isym, nt, v, w, idvw, jdvw, a, b, mdab, ndab, &
        wvhsec, pertrb, ierror)

        ! Dummy arguments
        integer(ip), intent(in)  :: nlat
        integer(ip), intent(in)  :: nlon
        integer(ip), intent(in)  :: isym
        integer(ip), intent(in)  :: nt
        real(wp),    intent(out) :: v(idvw, jdvw, nt)
        real(wp),    intent(out) :: w(idvw, jdvw, nt)
        integer(ip), intent(in)  :: idvw
        integer(ip), intent(in)  :: jdvw
        real(wp),    intent(in)  :: a(mdab, ndab, nt)
        real(wp),    intent(in)  :: b(mdab, ndab, nt)
        integer(ip), intent(in)  :: mdab
        integer(ip), intent(in)  :: ndab
        real(wp),    intent(out) :: wvhsec(:)
        real(wp),    intent(out) :: pertrb(nt)
        integer(ip), intent(out) :: ierror

        ! Local variables
        integer(ip) :: required_wavetable_size
        type(VectorSynthesisUtility) :: util

        ! Check input arguments
        required_wavetable_size = util%get_lvhsec(nlat, nlon)

        call util%check_vector_transform_inputs(isym, idvw, jdvw, &
            mdab, ndab, nlat, nlon, nt, required_wavetable_size, &
            wvhsec, ierror)

        ! Check error flag
        if (ierror /= 0) return

        call invert_divergence_lower_utility_routine(nlat, nlon, isym, nt, &
            v, w, idvw, jdvw, a, b, wvhsec, pertrb, vhsec, ierror)

    end subroutine idivec

end submodule invert_divergence_regular_grid
