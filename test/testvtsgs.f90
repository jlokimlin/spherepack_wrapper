!
!     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
!     *                                                               *
!     *                  copyright (c) 1998 by UCAR                   *
!     *                                                               *
!     *       University Corporation for Atmospheric Research         *
!     *                                                               *
!     *                      all rights reserved                      *
!     *                                                               *
!     *                          Spherepack                           *
!     *                                                               *
!     *       A Package of Fortran77 Subroutines and Programs         *
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
!
!program tvtsgs
!    use spherepack
!    implicit none
!    real(wp) :: a
!    real(wp) :: b
!    real(wp) :: bi
!    real(wp) :: br
!    real(wp) :: c
!    real(wp) :: ci
!    real(wp) :: cr
!    real(wp) :: da
!    real(wp) :: db
!    real(wp) :: dmax1
!    real(wp) :: dmax2
!    real(wp) :: dphi
!    real(wp) :: dtr
!    real(wp) :: hpi
!    integer(ip) :: i
!    integer(ip) :: idp
!    integer(ip) :: ierror
!    integer(ip) :: iq
!    integer(ip) :: isym
!    integer(ip) :: j
!    integer(ip) :: jdp
!    integer(ip) :: jq
!    integer(ip) :: k
!    integer(ip) :: ldwork
!    integer(ip) :: lwork
!    integer(ip) :: lwshi
!    integer(ip) :: lwvha
!    integer(ip) :: lwvhs
!    integer(ip) :: lwvts
!    integer(ip) :: mdab
!    integer(ip) :: mp1
!    integer(ip) :: ndab
!    integer(ip) :: nlat
!    integer(ip) :: nlon
!    integer(ip) :: np1
!    integer(ip) :: nt
!    real(wp) :: phi
!
!    real(wp) :: s
!    real(wp) :: theta
!    real(wp) :: tmp
!    real(wp) :: u
!    real(wp) :: v
!    real(wp) :: vt
!    real(wp) :: w
!    real(wp) :: work
!    real(wp) :: wshi
!    real(wp) :: wt
!    real(wp) :: wvha
!    real(wp) :: wvhs
!    real(wp) :: wvts
!    real(wp) :: x
!    real(wp) :: y
!    real(wp) :: z
!    !
!    !     this program checks vtsgs for computing the colatitudinal
!    !     derivatives of the velocity ....
!    !
!    parameter (nlat=17, nlon=32)
!    parameter (idp=nlat, jdp=nlon, mdab=nlat, ndab=nlat)
!    !
!    dimension u(idp, jdp), v(idp, jdp), w(idp, jdp), &
!        x(idp, jdp), y(idp, jdp), z(idp, jdp), &
!        vt(idp, jdp), wt(idp, jdp), &
!        a(mdab, ndab, 3), b(mdab, ndab, 3), &
!        da(mdab, ndab, 3, 3), db(mdab, ndab, 3, 3), &
!        tmp(mdab, ndab), br(mdab, ndab), bi(mdab, ndab), &
!        cr(mdab, ndab), ci(mdab, ndab), &
!        c(idp, jdp, 3, 3), s(idp, jdp, 3, 3), &
!        dthet(idp), dwts(idp)
!    dimension wshi(608411), wvha(1098771), wvhs(1098771), &
!        wvts(1098771), work(165765)
!    real dthet, dwts, dwork(25741)
!    !
!    lwshi = 608411
!    lwvha = 1098771
!    lwvhs = 1098771
!    lwvts = 1098771
!    lwork = 165765
!    ldwork = 25741
!    !
!    hpi = pi/2.
!    dtr = pi/180.
!    isym = 0
!    nt = 1
!    !
!    !     initialize spherepack routines
!    !
!    call shigs(nlat, nlon, wshi, lwshi, work, lwork, dwork, ldwork, ierror)
!    if(ierror /= 0) write (6, 55) ierror
!55  format('testvtsgs:  error' i4 ' in shigs')
!    call vhagsi(nlat, nlon, wvha, lwvha, dwork, ldwork, ierror)
!    if(ierror /= 0) write (6, 57) ierror
!57  format('testvtsgs:  error' i4 ' in vhagsi')
!    call vhsgsi(nlat, nlon, wvhs, lwvhs, dwork, ldwork, ierror)
!    if(ierror /= 0) write (6, 58) ierror
!58  format(' testvtsgs: error' i4 ' in vhsgsi')
!    call vtsgsi(nlat, nlon, wvts, lwvts, work, lwork, dwork, ldwork, ierror)
!    if(ierror /= 0) write (6, 59) ierror
!59  format(' testvtsgs: error' i4 ' in vtsgsi')
!    !
!    !     compute gauss points and weights
!    !
!    call compute_gaussian_latitudes_and_weights(nlat, dthet, dwts, work, lwork, ierror)
!    !
!    !     zero vector harmonic coefficients
!    !
!    do np1=1, nlat
!        do mp1=1, np1
!            br(mp1, np1) = 0.
!            bi(mp1, np1) = 0.
!            cr(mp1, np1) = 0.
!            ci(mp1, np1) = 0.
!        end do
!    end do
!    !
!    !     initialize arrays with random numbers
!    !     old style non-portable commented out
!    !
!    !     call srand(227)
!    !     do np1=1, nlat-1
!    !     do mp1=1, np1
!    !     br(mp1, np1) = rand()
!    !     bi(mp1, np1) = rand()
!    !     cr(mp1, np1) = rand()
!    !     ci(mp1, np1) = rand()
!    !     end do
!    !     end do
!    !
!    !     set vector harmonic coefficients
!    !     (new style using standard Fortran90
!    !     intrinsics
!    !
!    call RANDOM_SEED()
!    !
!    call RANDOM_NUMBER(tmp)
!    do np1=1, nlat-1
!        do mp1=1, np1
!            br(mp1, np1) = tmp(mp1, np1)
!        end do
!    end do
!    !
!    call RANDOM_NUMBER(tmp)
!    do np1=1, nlat-1
!        do mp1=1, np1
!            bi(mp1, np1) = tmp(mp1, np1)
!        end do
!    end do
!    !
!    call RANDOM_NUMBER(tmp)
!    do np1=1, nlat-1
!        do mp1=1, np1
!            cr(mp1, np1) = tmp(mp1, np1)
!        end do
!    end do
!    !
!    call RANDOM_NUMBER(tmp)
!    do np1=1, nlat-1
!        do mp1=1, np1
!            ci(mp1, np1) = tmp(mp1, np1)
!        end do
!    end do
!    !
!    call vhsgs(nlat, nlon, 0, 1, v, w, idp, jdp, br, bi, &
!        cr, ci, mdab, ndab, wvhs, lwvhs, work, lwork, ierror)
!    if(ierror /= 0) write (6, 79) ierror
!79  format(' testvtsgs: error' i4 ' in vhsgs at point 1')
!    !
!    do j=1, nlon
!        do i=1, nlat
!            u(i, j) = 0.
!        end do
!    end do
!    !
!    !     convert to cartesian coordinates
!    !
!    dphi = 2.*pi/nlon
!    do j=1, nlon
!        phi = (j-1)*dphi
!        do i=1, nlat
!            theta = dthet(i)
!            call stoc(theta, phi, u(i, j), v(i, j), w(i, j), x(i, j), y(i, j), z(i, j))
!        end do
!    end do
!    !
!    !     compute harmonic components of x component
!    !
!    call shags(nlat, nlon, 0, 1, x, idp, jdp, a(1, 1, 1), b(1, 1, 1), &
!        mdab, ndab, wshi, lwshi, work, lwork, ierror)
!    if(ierror /= 0) write (6, 16) ierror
!16  format(' testvtsgs: error' i4 ' in shags at point 2')
!    !
!    !     write harmonic coefficients for x
!    !
!    !      write (6, 20)
!    ! 20   format(//'  harmonic coefficients for x'//)
!    !      do mp1=1, nlat
!    !      do np1=mp1, nlat
!    !      write (6, 5) mp1, np1, a(mp1, np1, 1), b(mp1, np1, 1)
!    ! 5    format(2i5, 1p2e15.6)
!    !      end do
!    !      end do
!    !
!    !     compute harmonic components of y component
!    !
!    call shags(nlat, nlon, 0, 1, y, idp, jdp, a(1, 1, 2), b(1, 1, 2), &
!        mdab, ndab, wshi, lwshi, work, lwork, ierror)
!    if(ierror /= 0) write (6, 17) ierror
!17  format(' testvtsgs: error' i4 ' in shags at point 3')
!    !
!    !     write harmonic coefficients for y
!    !
!    !      write (6, 21)
!    ! 21   format(//'  harmonic coefficients for y'//)
!    !      do mp1=1, nlat
!    !      do np1=mp1, nlat
!    !      write (6, 5) mp1, np1, a(mp1, np1, 2), b(mp1, np1, 2)
!    !      end do
!    !      end do
!    !
!    !     compute harmonic components of z component
!    !
!    call shags(nlat, nlon, 0, 1, z, idp, jdp, a(1, 1, 3), b(1, 1, 3), &
!        mdab, ndab, wshi, lwshi, work, lwork, ierror)
!    if(ierror /= 0) write (6, 18) ierror
!18  format(' testvtsgs: error' i4 ' in shags at point 4')
!    !
!    !     write harmonic coefficients for z
!    !
!    !      write (6, 22)
!    ! 22   format(//'  harmonic coefficients for z'//)
!    !      do mp1=1, nlat
!    !      do np1=mp1, nlat
!    !      write (6, 5) mp1, np1, a(mp1, np1, 3), b(mp1, np1, 3)
!    !      end do
!    !      end do
!    !
!    !     compute partials of x, y, and z wrt z
!    !
!    call dbdz(nlat, nlat, a(1, 1, 1), b(1, 1, 1), da(1, 1, 1, 3), db(1, 1, 1, 3))
!    call dbdz(nlat, nlat, a(1, 1, 2), b(1, 1, 2), da(1, 1, 2, 3), db(1, 1, 2, 3))
!    call dbdz(nlat, nlat, a(1, 1, 3), b(1, 1, 3), da(1, 1, 3, 3), db(1, 1, 3, 3))
!    !
!    !     compute partials of x, y, and z wrt y
!    !
!    call dbdy(nlat, nlat, a(1, 1, 1), b(1, 1, 1), da(1, 1, 1, 2), db(1, 1, 1, 2))
!    call dbdy(nlat, nlat, a(1, 1, 2), b(1, 1, 2), da(1, 1, 2, 2), db(1, 1, 2, 2))
!    call dbdy(nlat, nlat, a(1, 1, 3), b(1, 1, 3), da(1, 1, 3, 2), db(1, 1, 3, 2))
!    !
!    !     compute partials of x, y, and z wrt x
!    !
!    call dbdx(nlat, nlat, a(1, 1, 1), b(1, 1, 1), da(1, 1, 1, 1), db(1, 1, 1, 1))
!    call dbdx(nlat, nlat, a(1, 1, 2), b(1, 1, 2), da(1, 1, 2, 1), db(1, 1, 2, 1))
!    call dbdx(nlat, nlat, a(1, 1, 3), b(1, 1, 3), da(1, 1, 3, 1), db(1, 1, 3, 1))
!    !
!    !     transform cartesian jacobian to physical space
!    !
!    call shsgs(nlat, nlon, 0, 9, c, idp, jdp, da, db, idp, idp, &
!        wshi, lwshi, work, lwork, ierror)
!    if(ierror /= 0) write (6, 19) ierror
!19  format(' testvtsgs: error' i4 ' in shsgs at point 5')
!    !
!    !     convert to jacobian to spherical coordinates
!    !        (multiply cartesian jacobian by q)
!    !
!    do k=1, 3
!        do j=1, nlon
!            phi = (j-1)*dphi
!            do i=1, nlat
!                theta = dthet(i)
!                call ctos(theta, phi, c(i, j, 1, k), c(i, j, 2, k), c(i, j, 3, k), &
!                    s(i, j, 1, k), s(i, j, 2, k), s(i, j, 3, k))
!            end do
!        end do
!    end do
!    !
!    !     form s = (q sq**T)**T
!    !
!    do k=1, 3
!        do j=1, nlon
!            phi = (j-1)*dphi
!            do i=1, nlat
!                theta = dthet(i)
!                call ctos(theta, phi, s(i, j, k, 1), s(i, j, k, 2), s(i, j, k, 3), &
!                    c(i, j, k, 1), c(i, j, k, 2), c(i, j, k, 3))
!            end do
!        end do
!    end do
!
!    do j=1, nlon
!        do i=1, nlat
!            do iq=1, 3
!                do jq=1, 3
!                    s(i, j, iq, jq) = c(i, j, iq, jq)
!                end do
!            end do
!        end do
!    end do
!    !
!    !     check derivative program
!    !
!    call vtsgs(nlat, nlon, 0, 1, vt, wt, idp, jdp, br, bi, cr, ci, &
!        mdab, ndab, wvts, lwvts, work, lwork, ierror)
!    if(ierror /= 0) write (6, 4) ierror
!4   format(' testvtsgs: error' i4 ' in vtsgs during initialization')
!    dmax1 = 0.
!    dmax2 = 0.
!    do j=1, nlon
!        do i=1, nlat
!            dmax1 = max(dmax1, abs(s(i, j, 2, 2)-vt(i, j)))
!            dmax2 = max(dmax2, abs(s(i, j, 3, 2)-wt(i, j)))
!        end do
!    end do
!    write (6, 2) dmax1, dmax2
!2   format(' testvtsgs: error in vt '1pe15.6' error in wt '1pe15.6)
!end program tvtsgs
!subroutine ctos(theta, phi, x, y, z, u, v, w)
!    implicit none
!    real(wp) :: cp
!    real(wp) :: ct
!    real(wp) :: phi
!    real(wp) :: sp
!    real(wp) :: st
!    real(wp) :: temp1
!    real(wp) :: temp2
!    real(wp) :: theta
!    real(wp) :: u
!    real(wp) :: v
!    real(wp) :: w
!    real(wp) :: x
!    real(wp) :: y
!    real(wp) :: z
!    !
!    !     this program computes the components of a vector
!    !     field in spherical coordinates u, v, and w, from
!    !     its components x, y, and z in cartesian coordinates
!    !
!    st = sin(theta)
!    ct = cos(theta)
!    sp = sin(phi)
!    cp = cos(phi)
!    temp1 = cp*x+sp*y
!    temp2 = cp*y-sp*x
!    u = st*temp1+ct*z
!    v = ct*temp1-st*z
!    w = temp2
!    return
!end subroutine ctos
!subroutine stoc(theta, phi, u, v, w, x, y, z)
!    implicit none
!    real(wp) :: cp
!    real(wp) :: ct
!    real(wp) :: phi
!    real(wp) :: sp
!    real(wp) :: st
!    real(wp) :: temp1
!    real(wp) :: temp2
!    real(wp) :: theta
!    real(wp) :: u
!    real(wp) :: v
!    real(wp) :: w
!    real(wp) :: x
!    real(wp) :: y
!    real(wp) :: z
!    !
!    !     this program computes the components of a vector
!    !     field in cartesian coordinates x, y, and z, from
!    !     its components u, v, and w in spherical coordinates
!    !
!    st = sin(theta)
!    ct = cos(theta)
!    sp = sin(phi)
!    cp = cos(phi)
!    temp1 = st*u+ct*v
!    temp2 = ct*u-st*v
!    x = cp*temp1-sp*w
!    y = sp*temp1+cp*w
!    z = temp2
!    return
!end subroutine stoc
!subroutine dbdx(l, mdim, a, b, dxa, dxb)
!    implicit none
!    real(wp) :: a
!    real(wp) :: a1
!    real(wp) :: a2
!    real(wp) :: b
!    real(wp) :: cn
!    real(wp) :: dxa
!    real(wp) :: dxb
!    real(wp) :: fm
!    real(wp) :: fn
!    integer(ip) :: l
!    integer(ip) :: lm1
!    integer(ip) :: mdim
!    integer(ip) :: mp1
!    integer(ip) :: n
!    integer(ip) :: np1
!    !
!    !     subroutine to compute the coefficients in the spherical
!    !     harmonic representation of the derivative with respect to x
!    !     of a scalar function. i.e. given the coefficients a and b
!    !     in the spectral representation of a function, then dbdx
!    !     computes the coefficients dxa and dxb in the spectral
!    !     representation of the derivative of the function
!    !     with respect to x.
!    !
!    !     the arrays a and dxa can be the same as well as the arrays
!    !     b and dxb, i.e. the arrays a and b can be overwritten by
!    !     dxa and dxb respectively.
!    !
!    !     dimension a(mdim, 1), b(mdim, 1), dxa(mdim, 1), dxb(mdim, 1)
!    dimension a(mdim, *), b(mdim, *), dxa(mdim, *), dxb(mdim, *)
!    dxa(1, 1) = sqrt(6.)*a(2, 2)
!    dxb(1, 1) = 0.
!    lm1 = l-1
!    do 10 np1=2, lm1
!        n = np1-1
!        fn = real(n)
!        cn = (fn+fn+3.)/(fn+fn+1.)
!        dxa(1, np1) = sqrt(cn*(fn+2.)*(fn+1.))*a(2, np1+1)
!        dxb(1, np1) = 0.
!        do 10 mp1=2, np1
!            fm = real(mp1-1)
!            a1 = .5*sqrt(cn*(fn+fm+2.)*(fn+fm+1.))
!            a2 = .5*sqrt(cn*(fn-fm+2.)*(fn-fm+1.))
!            dxa(mp1, np1) = a1*a(mp1+1, np1+1)-a2*a(mp1-1, np1+1)
!            dxb(mp1, np1) = a1*b(mp1+1, np1+1)-a2*b(mp1-1, np1+1)
!10      continue
!        do 5 mp1=1, l
!            dxa(mp1, l) = 0.
!            dxb(mp1, l) = 0.
!5       continue
!        return
!    end subroutine dbdx
!    subroutine dbdy(l, mdim, a, b, dya, dyb)
!        implicit none
!        real(wp) :: a
!        real(wp) :: a1
!        real(wp) :: a2
!        real(wp) :: b
!        real(wp) :: cn
!        real(wp) :: dya
!        real(wp) :: dyb
!        real(wp) :: fm
!        real(wp) :: fn
!        integer(ip) :: l
!        integer(ip) :: lm1
!        integer(ip) :: mdim
!        integer(ip) :: mp1
!        integer(ip) :: n
!        integer(ip) :: np1
!        !
!        !     subroutine to compute the coefficients in the spherical
!        !     harmonic representation of the derivative with respect to y
!        !     of a scalar function. i.e. given the coefficients a and b
!        !     in the spectral representation of a function, then dbdy
!        !     computes the coefficients dya and dyb in the spectral
!        !     representation of the derivative of the function
!        !     with respect to y.
!        !
!        !     the arrays a and dya can be the same as well as the arrays
!        !     b and dyb, i.e. the arrays a and b can be overwritten by
!        !     dya and dyb respectively.
!        !
!        !     dimension a(mdim, 1), b(mdim, 1), dya(mdim, 1), dyb(mdim, 1)
!        dimension a(mdim, *), b(mdim, *), dya(mdim, *), dyb(mdim, *)
!        dya(1, 1) = -sqrt(6.)*b(2, 2)
!        dyb(1, 1) = 0.
!        lm1 = l-1
!        do 10 np1=2, lm1
!            n = np1-1
!            fn = real(n)
!            cn = (fn+fn+3.)/(fn+fn+1.)
!            dya(1, np1) = -sqrt(cn*(fn+2.)*(fn+1.))*b(2, np1+1)
!            dyb(1, np1) = 0.
!            do 10 mp1=2, np1
!                fm = real(mp1-1)
!                a1 = .5*sqrt(cn*(fn+fm+2.)*(fn+fm+1.))
!                a2 = .5*sqrt(cn*(fn-fm+2.)*(fn-fm+1.))
!                dya(mp1, np1) = -a1*b(mp1+1, np1+1)-a2*b(mp1-1, np1+1)
!                dyb(mp1, np1) =  a1*a(mp1+1, np1+1)+a2*a(mp1-1, np1+1)
!10          continue
!            do 5 mp1=1, l
!                dya(mp1, l) = 0.
!                dyb(mp1, l) = 0.
!5           continue
!            return
!        end subroutine dbdy
!        subroutine dbdz(l, mdim, a, b, dza, dzb)
!            implicit none
!            real(wp) :: a
!            real(wp) :: a1
!            real(wp) :: b
!            real(wp) :: cn
!            real(wp) :: dza
!            real(wp) :: dzb
!            real(wp) :: fm
!            real(wp) :: fn
!            integer(ip) :: l
!            integer(ip) :: lm1
!            integer(ip) :: mdim
!            integer(ip) :: mp1
!            integer(ip) :: n
!            integer(ip) :: np1
!            !
!            !     subroutine to compute the coefficients in the spherical
!            !     harmonic representation of the derivative with respect to z
!            !     of a scalar function. i.e. given the coefficients a and b
!            !     in the spectral representation of a function, then dbdz
!            !     computes the coefficients dza and dzb in the spectral
!            !     representation of the derivative of the function
!            !     with respect to z.
!            !
!            !     the arrays a and dza can be the same as well as the arrays
!            !     b and dzb, i.e. the arrays a and b can be overwritten by
!            !     dza and dzb respectively.
!            !
!            dimension a(mdim, 1), b(mdim, 1), dza(mdim, 1), dzb(mdim, 1)
!            lm1 = l-1
!            do 10 np1=1, lm1
!                n = np1-1
!                fn = real(n)
!                cn = (fn+fn+3.)/(fn+fn+1.)
!                do 10 mp1=1, np1
!                    fm = real(mp1-1)
!                    a1 = sqrt(cn*(fn-fm+1.)*(fn+fm+1.))
!                    dza(mp1, np1) = a1*a(mp1, np1+1)
!                    dzb(mp1, np1) = a1*b(mp1, np1+1)
!10              continue
!                do 5 mp1=1, l
!                    dza(mp1, l) = 0.
!                    dzb(mp1, l) = 0.
!5               continue
!                return
!            end subroutine dbdz


