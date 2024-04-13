! Fortran module dates that contains the following definitions:
! • a data type date having three components day, month, and year
!• a logical function isLeapYear(year) that checks if year is a leap year
!• a subroutine checkDate(d) that checks if d is a valid date; if not, d is set to a default date (01.01.1970)
!• a subroutine incDay(d) that sets d to the next day
!• a subroutine printDate(d) that prints a date in the format DD.MM.YYYY

module dates
  implicit none
  type date 
     integer :: day
     integer :: month
     integer :: year
  end type date

contains
  function isleapyear(year) result(f)! logical function to check year
    implicit none 
    integer, intent(in) :: year
    logical :: f
    f = .false.

    if (mod(year,4) == 0 .and. mod(year,100) /= 0 .or. mod(year,400) == 0) then
       f = .true.
    endif
  end function isleapyear

  subroutine checkDate (d) ! check for valid date or set to default date 01.01.1970
    implicit none
    type(date) , intent(inout) :: d
    integer, dimension(12) :: dayspermonth = (/ 31, 28, 31, 30, 31, 30, 31, 31, 30,31, 30, 31 /)

    if (d%year.lt.1 .or. d%month.lt.1 .or. d%month.gt.12 .or. d%day.lt.1 &
         .or. (d%day.gt.daysPerMonth(d%month) .and. (.not.(d%day == 29.and. &
         d%month == 2 .and. isLeapYear(d%year))))) then 
       print*, "Invalid Date!! setting it to default 01.01.1970"
       d%day = 1
       d%month = 1
       d%year = 1970
    endif

  end subroutine checkDate

  subroutine incDay(d)  ! sets to next day
    implicit none
    type(date) , intent(inout) :: d
    integer, dimension(12) :: dayspermonth = (/ 31, 28, 31, 30, 31, 30, 31, 31, 30,31, 30, 31 /)
    d%day = d%day + 1
    if (d%day > daysPerMonth(d%month) .and. (.not.(d%day == 29 .and. d%month == 2 .and. isLeapYear(d%year)))) then
       d%day = 1;
       if (d%month+1 == 13) then ! d%month is not increased
          d%month = 1;
          d%year = d%year+1
       endif
    endif
  end subroutine incDay

  subroutine printDate(d) !prints the date in the format DD.MM.YYYY
    implicit none
    type(date), intent(inout) :: d
    write (*, '(/i2.2, ":", i2.2, ":",i4)') d%day, d%month, d%year
  end subroutine printDate

end module dates
