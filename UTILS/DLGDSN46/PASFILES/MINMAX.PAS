Unit MinMax;

Interface

Function IntMin(A, B : Integer) : Integer;
{Returns the minimum of two integers}
Inline(
  $5A/                   {Pop dx}
  $58/                   {pop ax}
  $39/$D0/               {cmp ax,dx}
  $7E/$01/               { jle xx}
  $92);                  {xchg ax,dx}
                         {xx:}

Function IntMax(A, B : Integer) : Integer;
{Returns the maximum of two integers}
Inline(
  $5A/                   {Pop dx}
  $58/                   {pop ax}
  $39/$D0/               {cmp ax,dx}
  $7D/$01/               { jge yy}
  $92);                  {xchg ax,dx}
                         {yy:}
Implementation

end.
