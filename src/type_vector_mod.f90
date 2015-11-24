!
!  Purpose:
!
!  Defines a derived data type for 3 dimensional cartesian vector calculations
!
module type_vector_mod

    use, intrinsic :: iso_fortran_env, only: &
        REAL64, &
        INT32

    ! Explicit typing only
    implicit none

    ! Everything is private unless stated otherwise
    private
    public :: &
        assignment(=), &
        operator(*), &
        ex, &
        ey, &
        ez

    ! Local variables confined to the module
    integer, parameter    :: WP   = REAL64  !! 64 bit real
    integer, parameter    :: IP   = INT32   !! 32 bit integer
    real (WP), parameter  :: ZERO = 0.0_WP  !! To define the unit vectors
    real (WP), parameter  :: ONE  = 1.0_WP  !! To define the unit vectors

    ! Declare derived data type
    type, public :: vector_t

        real (WP) :: x = 0.0_WP
        real (WP) :: y = 0.0_WP
        real (WP) :: z = 0.0_WP

    contains

        ! All procedures are private unless explicity stated otherwise
        private

        procedure :: Get_vector_add
        procedure :: Get_vector_subtract
        procedure :: Get_vector_div_real
        procedure :: Get_vector_div_int
        procedure :: Get_dot_product

        generic, public   :: operator (+) => &
            Get_vector_add

        generic, public  :: operator (-) => &
            Get_vector_subtract

        generic, public   :: operator (/) => &
            Get_vector_div_real, &
            Get_vector_div_int

        generic, public   :: operator (.dot.) => &
            Get_dot_product

    end type vector_t

    ! declare interface operators
    interface assignment (=)

        module procedure Get_array_to_vector
        module procedure Get_vector_to_array

    end interface

    interface operator (*)

        module procedure Get_vector_times_real
        module procedure Get_real_times_vector
        module procedure Get_vector_times_int
        module procedure Get_int_times_vector
        module procedure Get_cross_product

    end interface

    ! Pointer of "vector_t" for creating array of pointers of "vector_t".
    type, public :: vector_ptr

        type(vector_t), pointer :: p => null()

    end type vector_ptr

    ! The Cartesian unit vectors
    type(vector_t), parameter :: ex = vector_t( ONE , ZERO, ZERO ) ! x-direction
    type(vector_t), parameter :: ey = vector_t( ZERO, ONE , ZERO ) ! y-direction
    type(vector_t), parameter :: ez = vector_t( ZERO, ZERO, ONE )  ! z-direction

contains
    !
    !*****************************************************************************************
    !
    subroutine Get_array_to_vector( me_result, array )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        class (vector_t), intent (out)         :: me_result
        real (WP), dimension (3), intent (in)  :: array
        !--------------------------------------------------------------------------------

        me_result%x = array(1)
        me_result%y = array(2)
        me_result%z = array(3)

    end subroutine Get_array_to_vector
    !
    !*****************************************************************************************
    !
    subroutine Get_vector_to_array( array_result, me )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        real (WP), dimension (3), intent (out) :: array_result
        class (vector_t), intent (in)         :: me
        !--------------------------------------------------------------------------------

        array_result(1) = me%x
        array_result(2) = me%y
        array_result(3) = me%z

    end subroutine Get_vector_to_array
    !
    !*****************************************************************************************
    !
    function Get_vector_add( vec_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        class (vector_t), intent (in) :: vec_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x + vec_2%x
        return_value%y = vec_1%y + vec_2%y
        return_value%z = vec_1%z + vec_2%z

    end function Get_vector_add
    !
    !*****************************************************************************************
    !
    !
    !*****************************************************************************************
    !
    function Get_vector_subtract( vec_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)              :: return_value
        class (vector_t), intent (in) :: vec_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x - vec_2%x
        return_value%y = vec_1%y - vec_2%y
        return_value%z = vec_1%z - vec_2%z

    end function Get_vector_subtract
    !
    !*****************************************************************************************
    !
    function Get_vector_times_real( vec_1, real_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        class (vector_t), intent (in) :: vec_1
        real (WP), intent (in)         :: real_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x * real_2
        return_value%y = vec_1%y * real_2
        return_value%z = vec_1%z * real_2

    end function Get_vector_times_real
    !
    !*****************************************************************************************
    !
    function Get_real_times_vector(real_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        real (WP), intent (in)         :: real_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value%x = real_1 * vec_2%x
        return_value%y = real_1 * vec_2%y
        return_value%z = real_1 * vec_2%z

    end function Get_real_times_vector
    !
    !*****************************************************************************************
    !
    function Get_vector_times_int( vec_1, int_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        class (vector_t), intent (in) :: vec_1
        integer (IP), intent (in)      :: int_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x * real(int_2, WP)
        return_value%y = vec_1%y * real(int_2, WP)
        return_value%z = vec_1%z * real(int_2, WP)

    end function Get_vector_times_int
    !
    !*****************************************************************************************
    !
    function Get_int_times_vector(int_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        integer (IP), intent (in)      :: int_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value%x = real(int_1, WP) * vec_2%x
        return_value%y = real(int_1, WP) * vec_2%y
        return_value%z = real(int_1, WP) * vec_2%z

    end function Get_int_times_vector
    !
    !*****************************************************************************************
    !
    function Get_vector_div_real( vec_1, real_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)                :: return_value
        class (vector_t), intent (in)  :: vec_1
        real (WP), intent (in)          :: real_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x / real_2
        return_value%y = vec_1%y / real_2
        return_value%z = vec_1%z / real_2

    end function Get_vector_div_real
    !
    !*****************************************************************************************
    !
    function Get_vector_div_int( vec_1, int_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)                :: return_value
        class (vector_t), intent (in)  :: vec_1
        integer (IP), intent (in)      :: int_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%x / int_2
        return_value%y = vec_1%y / int_2
        return_value%z = vec_1%z / int_2

    end function Get_vector_div_int
    !
    !*****************************************************************************************
    !
    function Get_dot_product( vec_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        real (WP)                      :: return_value
        class (vector_t), intent (in) :: vec_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value = &
            vec_1%x*vec_2%x &
            + vec_1%y*vec_2%y &
            + vec_1%z*vec_2%z 

    end function Get_dot_product
    !
    !*****************************************************************************************
    !
    function Get_cross_product( vec_1, vec_2 ) result ( return_value )
        !
        ! Purpose:
        !
        !--------------------------------------------------------------------------------
        ! Dictionary: calling arguments
        !--------------------------------------------------------------------------------
        type (vector_t)               :: return_value
        class (vector_t), intent (in) :: vec_1
        class (vector_t), intent (in) :: vec_2
        !--------------------------------------------------------------------------------

        return_value%x = vec_1%y*vec_2%z - vec_1%z*vec_2%y
        return_value%y = vec_1%z*vec_2%x - vec_1%x*vec_2%z
        return_value%z = vec_1%x*vec_2%y - vec_1%y*vec_2%x

    end function Get_cross_product
    !
    !*****************************************************************************************
    !
end module type_vector_mod
