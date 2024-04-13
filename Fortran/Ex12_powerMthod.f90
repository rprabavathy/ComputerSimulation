! Fortran Program that computes the eigenvalue with largest absolute value 𝜆max of a Toeplitz matrix of size 𝑛 × 𝑛

program PowerMethod

  implicit none
  integer ::  n, i, j
  double precision, allocatable, dimension(:, :) ::  a
  double precision , allocatable, dimension(:) :: element 

  write (*, "(A)", advance = "no") "matrix size n: "
  read *, n
  allocate(a(n, n))
  allocate(element(n))

  element(1:3) =(/4 , -1, -2/) ! remaining elements not initialized to 0

  ! Creating Toeplitz Matrix
  do concurrent (i = 1 : n, j = 1 : n)
     if (i.le.j) then 
        a(i,j) = element(j-i+1)
     else 
        a(i,j) = element(i-j+1)
     end if
  end do

  write (*, "(A, G0.5)") "Largest absolute Eigen Value of Toeplitz Matrix A of size n = " , n , " is " , eigenValue(a)

contains
  subroutine mult(a, b, c)
    ! why do you not use the predefined function matmul?
    double precision, dimension(:, :), intent(in) :: a
    double precision, dimension(:), intent(in) :: b
    double precision, dimension(:), intent(out) :: c
    integer :: m, n, k
    double precision :: temp ! unused

    m = size(a)/size(a, 1)
    n = size(b)
    if (m == n) then 
       do k = 1, n
          c(k) = dot_product(a(1:m,k),b) 
       end do
    else
       print*, "Incorrect Dimenions!!"
    end if
  end subroutine mult

  double precision function eigenValue(a) result(eigen)
    double precision, dimension(:, :), intent(in) :: a
    double precision, allocatable, dimension(:) :: x,y,z
    allocate(x(size(a)/size(a, 1)))
    allocate(y(size(a)/size(a, 1)))
    allocate(z(size(a)/size(a, 1)))
    x = 1 
    call mult(a,x,y)
    eigen = abs(norm2(y,n))
    z = y/eigen
    do while(norm2(z-x) .gt. 10d-12)
       x = z    
       call mult(a,x,y)
       eigen = abs(norm2(y,n))
       z = y/eigen
    end do
  end function eigenValue
end program PowerMethod
