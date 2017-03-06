module vector_analysis_routines

    use spherepack_precision, only: &
        wp, & ! working precision
        ip, & ! integer precision
        PI

    use type_SpherepackUtility, only: &
        SpherepackUtility

    use gaussian_latitudes_and_weights_routines, only: &
        compute_gaussian_latitudes_and_weights

    ! Explicit typing only
    implicit none

    ! Everything is private unless stated otherwise
    public :: vhagc, vhagci, initialize_vhaec
    public :: vhaes, vhaesi, initialize_vhaes
    public :: vhaec, vhaeci, initialize_vhagc
    public :: vhags, vhagsi, initialize_vhags
    public :: VectorAnalysisUtility

    ! Parameters confined to the module
    real(wp), parameter :: ZERO = 0.0_wp
    real(wp), parameter :: HALF = 0.5_wp
    real(wp), parameter :: ONE = 1.0_wp
    real(wp), parameter :: TWO = 2.0_wp
    real(wp), parameter :: FOUR = 4.0_wp

    type, public :: VectorAnalysisUtility
    contains
        ! Type-bound procedures
        procedure, nopass :: vhaec
        procedure, nopass :: vhagc
        procedure, nopass :: vhaes
        procedure, nopass :: vhags
        procedure, nopass :: initialize_vhaec
        procedure, nopass :: initialize_vhaes
        procedure, nopass :: initialize_vhagc
        procedure, nopass :: initialize_vhags
    end type VectorAnalysisUtility

    ! Declare interfaces for submodule implementation
    interface
        module subroutine vhaec(nlat, nlon, ityp, nt, v, w, idvw, jdvw, br, bi, cr, ci, &
            mdab, ndab, wvhaec, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            integer(ip), intent(in)  :: ityp
            integer(ip), intent(in)  :: nt
            real(wp),    intent(in)  :: v(idvw, jdvw, nt)
            real(wp),    intent(in)  :: w(idvw, jdvw, nt)
            integer(ip), intent(in)  :: idvw
            integer(ip), intent(in)  :: jdvw
            real(wp),    intent(out) :: br(mdab, ndab, nt)
            real(wp),    intent(out) :: bi(mdab, ndab, nt)
            real(wp),    intent(out) :: cr(mdab, ndab, nt)
            real(wp),    intent(out) :: ci(mdab, ndab, nt)
            integer(ip), intent(in)  :: mdab
            integer(ip), intent(in)  :: ndab
            real(wp),    intent(in)  :: wvhaec(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhaec

        module subroutine vhaes(nlat, nlon, ityp, nt, v, w, idvw, jdvw, br, bi, cr, ci, &
            mdab, ndab, wvhaes, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            integer(ip), intent(in)  :: ityp
            integer(ip), intent(in)  :: nt
            real(wp),    intent(in)  :: v(idvw, jdvw, nt)
            real(wp),    intent(in)  :: w(idvw, jdvw, nt)
            integer(ip), intent(in)  :: idvw
            integer(ip), intent(in)  :: jdvw
            real(wp),    intent(out) :: br(mdab, ndab, nt)
            real(wp),    intent(out) :: bi(mdab, ndab, nt)
            real(wp),    intent(out) :: cr(mdab, ndab, nt)
            real(wp),    intent(out) :: ci(mdab, ndab, nt)
            integer(ip), intent(in)  :: mdab
            integer(ip), intent(in)  :: ndab
            real(wp),    intent(in)  :: wvhaes(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhaes

        module subroutine vhagc(nlat, nlon, ityp, nt, v, w, idvw, jdvw, br, bi, cr, ci, &
            mdab, ndab, wvhagc, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            integer(ip), intent(in)  :: ityp
            integer(ip), intent(in)  :: nt
            real(wp),    intent(in)  :: v(idvw, jdvw, nt)
            real(wp),    intent(in)  :: w(idvw, jdvw, nt)
            integer(ip), intent(in)  :: idvw
            integer(ip), intent(in)  :: jdvw
            real(wp),    intent(out) :: br(mdab, ndab, nt)
            real(wp),    intent(out) :: bi(mdab, ndab, nt)
            real(wp),    intent(out) :: cr(mdab, ndab, nt)
            real(wp),    intent(out) :: ci(mdab, ndab, nt)
            integer(ip), intent(in)  :: mdab
            integer(ip), intent(in)  :: ndab
            real(wp),    intent(in)  :: wvhagc(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhagc

        module subroutine vhags(nlat, nlon, ityp, nt, v, w, idvw, jdvw, br, bi, cr, ci, &
            mdab, ndab, wvhags, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            integer(ip), intent(in)  :: ityp
            integer(ip), intent(in)  :: nt
            real(wp),    intent(in)  :: v(idvw, jdvw, nt)
            real(wp),    intent(in)  :: w(idvw, jdvw, nt)
            integer(ip), intent(in)  :: idvw
            integer(ip), intent(in)  :: jdvw
            real(wp),    intent(out) :: br(mdab, ndab, nt)
            real(wp),    intent(out) :: bi(..)
            real(wp),    intent(out) :: cr(..)
            real(wp),    intent(out) :: ci(..)
            integer(ip), intent(in)  :: mdab
            integer(ip), intent(in)  :: ndab
            real(wp),    intent(in)  :: wvhags(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhags

        module subroutine vhaeci(nlat, nlon, wvhaec, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            real(wp),    intent(out) :: wvhaec(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhaeci

        module subroutine vhaesi(nlat, nlon, wvhaes, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            real(wp),    intent(out) :: wvhaes(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhaesi

        module subroutine vhagci(nlat, nlon, wvhagc, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            real(wp),    intent(out) :: wvhagc(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhagci

        module subroutine vhagsi(nlat, nlon, wvhags, ierror)

            ! Dummy arguments
            integer(ip), intent(in)  :: nlat
            integer(ip), intent(in)  :: nlon
            real(wp),    intent(out) :: wvhags(:)
            integer(ip), intent(out) :: ierror
        end subroutine vhagsi
    end interface

contains

    subroutine initialize_vhaec(nlat, nlon, wvhaec, error_flag)

        ! Dummy arguments
        integer(ip),           intent(in)  :: nlat
        integer(ip),           intent(in)  :: nlon
        real(wp), allocatable, intent(out) :: wvhaec(:)
        integer(ip),           intent(out) :: error_flag
        ! Local variables
        integer(ip) :: lvhaec

        ! Get required workspace size
        lvhaec = get_lvhaec(nlat, nlon)

        ! Allocate memory
        allocate (wvhaec(lvhaec))

        ! Initialize wavetable
        call vhaeci(nlat, nlon, wvhaec, error_flag)

    end subroutine initialize_vhaec

    subroutine initialize_vhaes(nlat, nlon, wvhaes, error_flag)

        ! Dummy arguments
        integer(ip),           intent(in)  :: nlat
        integer(ip),           intent(in)  :: nlon
        real(wp), allocatable, intent(out) :: wvhaes(:)
        integer(ip),           intent(out) :: error_flag

        ! Local variables
        integer(ip) :: lvhaes

        ! Get required workspace size
        lvhaes = get_lvhaes(nlat, nlon)

        ! Allocate memory
        allocate (wvhaes(lvhaes))

        ! Initialize wavetable
        call vhaesi(nlat, nlon, wvhaes, error_flag)

    end subroutine initialize_vhaes

    subroutine initialize_vhagc(nlat, nlon, wvhagc, error_flag)

        ! Dummy arguments
        integer(ip),           intent(in)  :: nlat
        integer(ip),           intent(in)  :: nlon
        real(wp), allocatable, intent(out) :: wvhagc(:)
        integer(ip),           intent(out) :: error_flag

        ! Local variables
        integer(ip) :: lvhagc

        ! Get required workspace size
        lvhagc = get_lvhagc(nlat, nlon)

        ! Allocate memory
        allocate (wvhagc(lvhagc))

        ! Initialize wavetable
        call vhagci(nlat, nlon, wvhagc, error_flag)

    end subroutine initialize_vhagc

    subroutine initialize_vhags(nlat, nlon, wvhags, error_flag)

        ! Dummy arguments
        integer(ip),           intent(in)  :: nlat
        integer(ip),           intent(in)  :: nlon
        real(wp), allocatable, intent(out) :: wvhags(:)
        integer(ip),           intent(out) :: error_flag

        ! Local variables
        integer(ip) :: lvhags

        ! Get required workspace size
        lvhags = get_lvhags(nlat, nlon)

        ! Allocate memory
        allocate (wvhags(lvhags))

        ! Initialize wavetable
        call vhagsi(nlat, nlon, wvhags, error_flag)

    end subroutine initialize_vhags

    pure function get_lvhagc(nlat, nlon) &
        result (return_value)

        ! Dummy arguments
        integer(ip), intent(in) :: nlat
        integer(ip), intent(in) :: nlon
        integer(ip)             :: return_value

        ! Local variables
        integer(ip)             :: n1, n2
        type(SpherepackUtility) :: util

        call util%compute_parity(nlat, nlon, n1, n2)

        return_value = 4*nlat*n2+3*max(n1-2, 0)*(2*nlat-n1-1)+nlon+n2+15

    end function get_lvhagc

    pure function get_lvhags(nlat, nlon) &
        result (return_value)

        ! Dummy arguments
        integer(ip), intent(in) :: nlat
        integer(ip), intent(in) :: nlon
        integer(ip)             :: return_value

        return_value = (((nlat + 1)**2) * nlat)/2 + nlon + 15

    end function get_lvhags

    pure function get_lvhaec(nlat, nlon) &
        result (return_value)

        ! Dummy arguments
        integer(ip), intent(in) :: nlat
        integer(ip), intent(in) :: nlon
        integer(ip)             :: return_value

        ! Local variables
        integer(ip)             :: n1, n2
        type(SpherepackUtility) :: util

        call util%compute_parity(nlat, nlon, n1, n2)

        return_value = 4*nlat*n2+3*max(n1-2, 0)*(nlat+nlat-n1-1)+nlon+15

    end function get_lvhaec

    pure function get_lvhaes(nlat, nlon) &
        result (return_value)

        ! Dummy arguments
        integer(ip), intent(in) :: nlat
        integer(ip), intent(in) :: nlon
        integer(ip)             :: return_value

        ! Local variables
        integer(ip)         :: n1, n2
        type(SpherepackUtility) :: util

        call util%compute_parity(nlat, nlon, n1, n2)

        return_value = n1*n2*(2*nlat-n1+1)+nlon+15

    end function get_lvhaes

end module vector_analysis_routines
