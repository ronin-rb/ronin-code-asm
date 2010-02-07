_start:
%if code == 0
	xorl eax,eax
%else
	movl eax,code
%endif
