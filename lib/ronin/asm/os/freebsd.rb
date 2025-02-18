# frozen_string_literal: true
#
# ronin-asm - A Ruby DSL for crafting Assembly programs and shellcode.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-asm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-asm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-asm.  If not, see <https://www.gnu.org/licenses/>.
#

require_relative '../config'

module Ronin
  module ASM
    module OS
      #
      # Contains FreeBSD specific helper methods.
      #
      module FreeBSD
        # System call numbers for FreeBSD.
        SYSCALLS = {
          exit: 1, # void exit(int rval);
          fork: 2, # int fork(void);
          read: 3, # user_ssize_t read(int fd, user_addr_t cbuf, user_size_t nbyte);
          write: 4, # user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte);
          open: 5, # int open(user_addr_t path, int flags, int mode);
          close: 6, # int close(int fd);
          wait4: 7, # int wait4(int pid, user_addr_t status, int options, user_addr_t rusage);
          old_create: 8, # int nosys(void); }   { old creat
          link: 9, # int link(user_addr_t path, user_addr_t link);
          unlink: 10, # int unlink(user_addr_t path);
          old_execve: 11, # int nosys(void); }   { old execv
          chdir: 12, # int chdir(user_addr_t path);
          fchdir: 13, # int fchdir(int fd);
          mknod: 14, # int mknod(user_addr_t path, int mode, int dev);
          chmod: 15, # int chmod(user_addr_t path, int mode);
          chown: 16, # int chown(user_addr_t path, int uid, int gid);
          old_break: 17, # int nosys(void); }   { old break
          getfsstat: 18, # int getfsstat(user_addr_t buf, int bufsize, int flags);
          old_lseek: 19, # int nosys(void); }   { old lseek
          getpid: 20, # int getpid(void);
          old_mount: 21, # int nosys(void); }   { old mount
          old_umount: 22, # int nosys(void); }   { old umount
          setuid: 23, # int setuid(uid_t uid);
          getuid: 24, # int getuid(void);
          geteuid: 25, # int geteuid(void);
          ptrace: 26, # int ptrace(int req, pid_t pid, caddr_t addr, int data);
          recvmsg: 27, # int recvmsg(int s, struct msghdr *msg, int flags);
          sendmsg: 28, # int sendmsg(int s, caddr_t msg, int flags);
          recvfrom: 29, # int recvfrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, int *fromlenaddr);
          accept: 30, # int accept(int s, caddr_t name, socklen_t
          getpeername: 31, # int getpeername(int fdes, caddr_t asa, socklen_t *alen);
          getsockname: 32, # int getsockname(int fdes, caddr_t asa, socklen_t *alen);
          access: 33, # int access(user_addr_t path, int flags);
          chflags: 34, # int chflags(char *path, int flags);
          fchflags: 35, # int fchflags(int fd, int flags);
          sync: 36, # int sync(void);
          kill: 37, # int kill(int pid, int signum, int posix);
          old_stat: 38, # int nosys(void); }   { old stat
          getppid: 39, # int getppid(void);
          old_lstat: 40, # int nosys(void); }   { old lstat
          dup: 41, # int dup(u_int fd);
          pipe: 42, # int pipe(void);
          getegid: 43, # int getegid(void);
          profil: 44, # int profil(short *bufbase, size_t bufsize, u_long pcoffset, u_int pcscale);
          old_ktrace: 45, # int nosys(void); } { old ktrace
          sigaction: 46, # int sigaction(int signum, struct __sigaction *nsa, struct sigaction *osa);
          getgid: 47, # int getgid(void);
          sigprocmask: 48, # int sigprocmask(int how, user_addr_t mask, user_addr_t omask);
          getlogin: 49, # int getlogin(char *namebuf, u_int namelen);
          setlogin: 50, # int setlogin(char *namebuf);
          acct: 51, # int acct(char *path);
          sigpending: 52, # int sigpending(struct sigvec *osv);
          sigaltstack: 53, # int sigaltstack(struct sigaltstack *nss, struct sigaltstack *oss);
          ioctl: 54, # int ioctl(int fd, u_long com, caddr_t data);
          reboot: 55, # int reboot(int opt, char *command);
          revoke: 56, # int revoke(char *path);
          symlink: 57, # int symlink(char *path, char *link);
          readlink: 58, # int readlink(char *path, char *buf, int count);
          execve: 59, # int execve(char *fname, char **argp, char **envp);
          umask: 60, # int umask(int newmask);
          chroot: 61, # int chroot(user_addr_t path);
          old_fstat: 62, # int nosys(void); }   { old fstat
          old_getpagesize: 64, # int nosys(void); }   { old getpagesize
          msync: 65, # int msync(caddr_t addr, size_t len, int flags);
          vfork: 66, # int vfork(void);
          old_vread: 67, # int nosys(void); }   { old vread
          old_write: 68, # int nosys(void); }   { old vwrite
          old_sbrk: 69, # int nosys(void); }   { old sbrk
          old_sstk: 70, # int nosys(void); }   { old sstk
          old_mmap: 71, # int nosys(void); }   { old mmap
          old_vadvise: 72, # int nosys(void); }   { old vadvise
          munmap: 73, # int munmap(caddr_t addr, size_t len);
          mprotect: 74, # int mprotect(caddr_t addr, size_t len, int prot);
          madvise: 75, # int madvise(caddr_t addr, size_t len, int behav);
          old_vhangup: 76, # int nosys(void); }   { old vhangup
          old_vlimit: 77, # int nosys(void); }   { old vlimit
          mincore: 78, # int mincore(user_addr_t addr, user_size_t len, user_addr_t vec);
          getgroups: 79, # int getgroups(u_int gidsetsize, gid_t *gidset);
          setgroups: 80, # int setgroups(u_int gidsetsize, gid_t *gidset);
          getpgrp: 81, # int getpgrp(void);
          setpgid: 82, # int setpgid(int pid, int pgid);
          setitimer: 83, # int setitimer(u_int which, struct itimerval *itv, struct itimerval *oitv);
          old_wait: 84, # int nosys(void); }   { old wait
          swapon: 85, # int swapon(void);
          getitimer: 86, # int getitimer(u_int which, struct itimerval *itv);
          oldgethostname: 87, # int nosys(void); }   { old gethostname
          sethostname: 88, # int nosys(void); }   { old sethostname
          getdtablesize: 89, # int getdtablesize(void);
          dup2: 90, # int dup2(u_int from, u_int to);
          old_getdopt: 91, # int nosys(void); }   { old getdopt
          fcntl: 92, # int fcntl(int fd, int cmd, long arg);
          select: 93, # int select(int nd, u_int32_t *in, u_int32_t *ou, u_int32_t *ex, struct timeval *tv);
          old_setdopt: 94, # int nosys(void); }   { old setdopt
          fsync: 95, # int fsync(int fd);
          setpriority: 96, # int setpriority(int which, id_t who, int prio);
          socket: 97, # int socket(int domain, int type, int protocol);
          connect: 98, # int connect(int s, caddr_t name, socklen_t namelen);
          old_accept: 99, # int nosys(void); }   { old accept
          getpriority: 100, # int getpriority(int which, id_t who);
          old_send: 101, # int nosys(void); }   { old send
          old_recv: 102, # int nosys(void); }   { old recv
          old_sigreturn: 103, # int nosys(void); }   { old sigreturn
          bind: 104, # int bind(int s, caddr_t name, socklen_t namelen);
          setsockopt: 105, # int setsockopt(int s, int level, int name, caddr_t val, socklen_t valsize);
          listen: 106, # int listen(int s, int backlog);
          old_vtimes: 107, # int nosys(void); }   { old vtimes
          old_sigvec: 108, # int nosys(void); }   { old sigvec
          old_sigblock: 109, # int nosys(void); }   { old sigblock
          old_sigsetmask: 110, # int nosys(void); }   { old sigsetmask
          sigsuspend: 111, # int sigsuspend(sigset_t mask);
          old_sigstack: 112, # int nosys(void); }   { old sigstack
          old_recvmsg: 113, # int nosys(void); }   { old recvmsg
          old_sendmsg: 114, # int nosys(void); }   { old sendmsg
          old_vtrace: 115, # int nosys(void); }   { old vtrace
          gettimeofday: 116, # int gettimeofday(struct timeval *tp, struct timezone *tzp);
          getrusage: 117, # int getrusage(int who, struct rusage *rusage);
          getsockopt: 118, # int getsockopt(int s, int level, int name, caddr_t val, socklen_t *avalsize);
          old_resuba: 119, # int nosys(void); }   { old resuba
          readv: 120, # user_ssize_t readv(int fd, struct iovec *iovp, u_int iovcnt);
          writev: 121, # user_ssize_t writev(int fd, struct iovec *iovp, u_int iovcnt);
          settimeofday: 122, # int settimeofday(struct timeval *tv, struct timezone *tzp);
          fchown: 123, # int fchown(int fd, int uid, int gid);
          fchmod: 124, # int fchmod(int fd, int mode);
          old_recvfrom: 125, # int nosys(void); }   { old recvfrom
          setreuid: 126, # int setreuid(uid_t ruid, uid_t euid);
          setregid: 127, # int setregid(gid_t rgid, gid_t egid);
          rename: 128, # int rename(char *from, char *to);
          old_truncate: 129, # int nosys(void); }   { old truncate
          old_ftruncate: 130, # int nosys(void); }   { old ftruncate
          flock: 131, # int flock(int fd, int how);
          mkfifo: 132, # int mkfifo(user_addr_t path, int mode);
          sendto: 133, # int sendto(int s, caddr_t buf, size_t len, int flags, caddr_t to, socklen_t tolen);
          shutdown: 134, # int shutdown(int s, int how);
          socketpair: 135, # int socketpair(int domain, int type, int protocol, int *rsv);
          mkdir: 136, # int mkdir(user_addr_t path, int mode);
          rmdir: 137, # int rmdir(char *path);
          utimes: 138, # int utimes(char *path, struct timeval *tptr);
          futimes: 139, # int futimes(int fd, struct timeval *tptr);
          adjtime: 140, # int adjtime(struct timeval *delta, struct timeval *olddelta);
          oldgetpeername: 141, # int nosys(void); }   { old getpeername
          gethostuuid: 142, # int gethostuuid(unsigned char *uuid_buf, const struct timespec *timeoutp);
          old_sethostid: 143, # int nosys(void); }   { old sethostid
          old_getrlimit: 144, # int nosys(void); }   { old getrlimit
          old_setrlimit: 145, # int nosys(void); }   { old setrlimit
          old_killpg: 146, # int nosys(void); }   { old killpg
          setsid: 147, # int setsid(void);
          old_setquota: 148, # int nosys(void); }   { old setquota
          old_qquota: 149, # int nosys(void); }   { old qquota
          old_getsockname: 150, # int nosys(void); }   { old getsockname
          getpgid: 151, # int getpgid(pid_t pid);
          setprivexec: 152, # int setprivexec(int flag);
          pread: 153, # user_ssize_t pread(int fd, user_addr_t buf, user_size_t nbyte, off_t offset);
          pwrite: 154, # user_ssize_t pwrite(int fd, user_addr_t buf, user_size_t nbyte, off_t offset);
          nfssvc: 155, # int nfssvc(int flag, caddr_t argp);
          old_getdirentries: 156, # int nosys(void); }   { old getdirentries
          statfs: 157, # int statfs(char *path, struct statfs *buf);
          fstatfs: 158, # int fstatfs(int fd, struct statfs *buf);
          unmount: 159, # int unmount(user_addr_t path, int flags);
          old_async_daemon: 160, # int nosys(void); }   { old async_daemon
          getfh: 161, # int getfh(char *fname, fhandle_t *fhp);
          old_getdomainname: 162, # int nosys(void); }   { old getdomainname
          old_setdomainname: 163, # int nosys(void); }   { old setdomainname
          quotactl: 165, # int quotactl(const char *path, int cmd, int uid, caddr_t arg);
          old_exportfs: 166, # int nosys(void); }   { old exportfs
          mount: 167, # int mount(char *type, char *path, int flags, caddr_t data);
          old_ustat: 168, # int nosys(void); }   { old ustat
          csops: 169, # int csops(pid_t pid, uint32_t ops, user_addr_t useraddr, user_size_t usersize);
          old_table: 170, # int nosys(void); }   { old table
          old_wait3: 171, # int nosys(void); }   { old wait3
          rpause: 172, # int nosys(void); }   { old rpause
          waitid: 173, # int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);
          old_getdents: 174, # int nosys(void); }   { old getdents
          old_gc_control: 175, # int nosys(void); }   { old gc_control
          add_profil: 176, # int add_profil(short *bufbase, size_t bufsize, u_long pcoffset, u_int pcscale);
          kdebug_trace: 180, # int kdebug_trace(int code, int arg1, int arg2, int arg3, int arg4, int arg5) NO_SYSCALL_STUB;
          setgid: 181, # int setgid(gid_t gid);
          setegid: 182, # int setegid(gid_t egid);
          seteuid: 183, # int seteuid(uid_t euid);
          sigreturn: 184, # int sigreturn(struct ucontext *uctx, int infostyle) NO_SYSCALL_STUB;
          chud: 185, # int chud(uint64_t code, uint64_t arg1, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5) NO_SYSCALL_STUB;
          fdatasync: 187, # int fdatasync(int fd);
          stat: 188, # int stat(user_addr_t path, user_addr_t ub);
          fstat: 189, # int fstat(int fd, user_addr_t ub);
          lstat: 190, # int lstat(user_addr_t path, user_addr_t ub);
          pathconf: 191, # int pathconf(char *path, int name);
          fpathconf: 192, # int fpathconf(int fd, int name);
          getrlimit: 194, # int getrlimit(u_int which, struct rlimit *rlp);
          setrlimit: 195, # int setrlimit(u_int which, struct rlimit *rlp);
          getdirentries: 196, # int getdirentries(int fd, char *buf, u_int count, long *basep);
          mmap: 197, # user_addr_t mmap(caddr_t addr, size_t len, int prot, int flags, int fd, off_t pos);
          lseek: 199, # off_t lseek(int fd, off_t offset, int whence);
          truncate: 200, # int truncate(char *path, off_t length);
          ftruncate: 201, # int ftruncate(int fd, off_t length);
          __sysctl: 202, # int __sysctl(int *name, u_int namelen, void *old, size_t *oldlenp, void *new, size_t newlen);
          mlock: 203, # int mlock(caddr_t addr, size_t len);
          munlock: 204, # int munlock(caddr_t addr, size_t len);
          undelete: 205, # int undelete(user_addr_t path);
          ATsocket: 206, # int ATsocket(int proto);
          ATgetmsg: 207, # int ATgetmsg(int fd, void *ctlptr, void *datptr, int *flags);
          ATputmsg: 208, # int ATputmsg(int fd, void *ctlptr, void *datptr, int flags);
          ATPsndreg: 209, # int ATPsndreq(int fd, unsigned char *buf, int len, int nowait);
          ATPsndrsp: 210, # int ATPsndrsp(int fd, unsigned char *respbuff, int resplen, int datalen);
          ATPgetreq: 211, # int ATPgetreq(int fd, unsigned char *buf, int buflen);
          ATPgetrsp: 212, # int ATPgetrsp(int fd, unsigned char *bdsp);
          #
          # System Calls 216 - 230 are reserved for calls to support HFS/HFS Plus
          # file system semantics. Currently, we only use 215-227.  The rest is
          # for future expansion in anticipation of new MacOS APIs for HFS Plus.
          # These calls are not conditionalized because while they are specific
          # to HFS semantics, they are not specific to the HFS filesystem.
          # We expect all filesystems to recognize the call and report that it is
          # not supported or to actually implement it.
          #
          mkcomplex: 216, # int mkcomplex(const char *path, mode_t mode, u_long type);
          statv: 217, # int statv(const char *path, struct vstat *vsb);
          lstatv: 218, # int lstatv(const char *path, struct vstat *vsb);
          fstatv: 219, # int fstatv(int fd, struct vstat *vsb);
          getattrlist: 220, # int getattrlist(const char *path, struct attrlist *alist, void *attributeBuffer, size_t bufferSize, u_long options);
          setattrlist: 221, # int setattrlist(const char *path, struct attrlist *alist, void *attributeBuffer, size_t bufferSize, u_long options);
          getdirentriesattr: 222, # int getdirentriesattr(int fd, struct attrlist *alist, void *buffer, size_t buffersize, u_long *count, u_long *basep, u_long *newstate, u_long options);
          exchangedata: 223, # int exchangedata(const char *path1, const char *path2, u_long options);
          old_fsgetpath: 224, # int nosys(void); } { old checkuseraccess / fsgetpath (which moved to 427)
          searchfs: 225, # int searchfs(const char *path, struct fssearchblock *searchblock, uint32_t *nummatches, uint32_t scriptcode, uint32_t options, struct searchstate *state);
          delete: 226, # int delete(user_addr_t path) NO_SYSCALL_STUB; }       { private delete (Carbon semantics)
          copyfile: 227, # int copyfile(char *from, char *to, int mode, int flags) NO_SYSCALL_STUB;
          fgetattrlist: 228, # int fgetattrlist(int fd, struct attrlist *alist, void *attributeBuffer, size_t bufferSize, u_long options);
          fsetattrlist: 229, # int fsetattrlist(int fd, struct attrlist *alist, void *attributeBuffer, size_t bufferSize, u_long options);
          poll: 230, # int poll(struct pollfd *fds, u_int nfds, int timeout);
          watchevent: 231, # int watchevent(struct eventreq *u_req, int u_eventmask);
          waitevent: 232, # int waitevent(struct eventreq *u_req, struct timeval *tv);
          modwatch: 233, # int modwatch(struct eventreq *u_req, int u_eventmask);
          getxattr: 234, # user_ssize_t getxattr(user_addr_t path, user_addr_t attrname, user_addr_t value, size_t size, uint32_t position, int options);
          fgetxattr: 235, # user_ssize_t fgetxattr(int fd, user_addr_t attrname, user_addr_t value, size_t size, uint32_t position, int options);
          setxattr: 236, # int setxattr(user_addr_t path, user_addr_t attrname, user_addr_t value, size_t size, uint32_t position, int options);
          fsetxattr: 237, # int fsetxattr(int fd, user_addr_t attrname, user_addr_t value, size_t size, uint32_t position, int options);
          removexattr: 238, # int removexattr(user_addr_t path, user_addr_t attrname, int options);
          fremovexattr: 239, # int fremovexattr(int fd, user_addr_t attrname, int options);
          listxattr: 240, # user_ssize_t listxattr(user_addr_t path, user_addr_t namebuf, size_t bufsize, int options);
          flistxattr: 241, # user_ssize_t flistxattr(int fd, user_addr_t namebuf, size_t bufsize, int options);
          fsctl: 242, # int fsctl(const char *path, u_long cmd, caddr_t data, u_int options);
          initgroups: 243, # int initgroups(u_int gidsetsize, gid_t *gidset, int gmuid);
          posix_spawn: 244, # int posix_spawn(pid_t *pid, const char *path, const struct _posix_spawn_args_desc *adesc, char **argv, char **envp);
          ffsctl: 245, # int ffsctl(int fd, u_long cmd, caddr_t data, u_int options);
          nfsclnt: 247, # int nfsclnt(int flag, caddr_t argp);
          fhopen: 248, # int fhopen(const struct fhandle *u_fhp, int flags);
          minherit: 250, # int minherit(void *addr, size_t len, int inherit);
          semsys: 251, # int semsys(u_int which, int a2, int a3, int a4, int a5);
          msgsys: 252, # int msgsys(u_int which, int a2, int a3, int a4, int a5);
          shmsys: 253, # int shmsys(u_int which, int a2, int a3, int a4);
          semctl: 254, # int semctl(int semid, int semnum, int cmd, semun_t arg);
          semget: 255, # int semget(key_t key, int
          semop: 256, # int semop(int semid, struct sembuf *sops, int nsops);
          msgctl: 258, # int msgctl(int msqid, int cmd, struct
          msgget: 259, # int msgget(key_t key, int msgflg);
          msgsnd: 260, # int msgsnd(int msqid, void *msgp, size_t msgsz, int msgflg);
          msgrcv: 261, # user_ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg);
          shmat: 262, # user_addr_t shmat(int shmid, void *shmaddr, int shmflg);
          shmctl: 263, # int shmctl(int shmid, int cmd, struct shmid_ds *buf);
          shmdt: 264, # int shmdt(void *shmaddr);
          shmget: 265, # int shmget(key_t key, size_t size, int shmflg);
          shm_open: 266, # int shm_open(const char *name, int oflag, int mode);
          shm_unlink: 267, # int shm_unlink(const char *name);
          sem_open: 268, # user_addr_t sem_open(const char *name, int oflag, int mode, int value);
          sem_close: 269, # int sem_close(sem_t *sem);
          sem_unlink: 270, # int sem_unlink(const char *name);
          sem_wait: 271, # int sem_wait(sem_t *sem);
          sem_trywait: 272, # int sem_trywait(sem_t *sem);
          sem_post: 273, # int sem_post(sem_t *sem);
          sem_getvalue: 274, # int sem_getvalue(sem_t *sem, int *sval);
          sem_init: 275, # int sem_init(sem_t *sem, int phsared, u_int value);
          sem_destroy: 276, # int sem_destroy(sem_t *sem);
          open_extended: 277, # int open_extended(user_addr_t path, int flags, uid_t uid, gid_t gid, int mode, user_addr_t xsecurity) NO_SYSCALL_STUB;
          umask_extended: 278, # int umask_extended(int newmask, user_addr_t xsecurity) NO_SYSCALL_STUB;
          stat_extended: 279, # int stat_extended(user_addr_t path, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          lstat_extended: 280, # int lstat_extended(user_addr_t path, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          fstat_extended: 281, # int fstat_extended(int fd, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          chmod_extended: 282, # int chmod_extended(user_addr_t path, uid_t uid, gid_t gid, int mode, user_addr_t xsecurity) NO_SYSCALL_STUB;
          fchmod_extended: 283, # int fchmod_extended(int fd, uid_t uid, gid_t gid, int mode, user_addr_t xsecurity) NO_SYSCALL_STUB;
          access_extended: 284, # int access_extended(user_addr_t entries, size_t size, user_addr_t results, uid_t uid) NO_SYSCALL_STUB;
          settid: 285, # int settid(uid_t uid, gid_t gid) NO_SYSCALL_STUB;
          gettid: 286, # int gettid(uid_t *uidp, gid_t *gidp) NO_SYSCALL_STUB;
          setsgroups: 287, # int setsgroups(int setlen, user_addr_t guidset) NO_SYSCALL_STUB;
          getsgroups: 288, # int getsgroups(user_addr_t setlen, user_addr_t guidset) NO_SYSCALL_STUB;
          setwgroups: 289, # int setwgroups(int setlen, user_addr_t guidset) NO_SYSCALL_STUB;
          getwgroups: 290, # int getwgroups(user_addr_t setlen, user_addr_t guidset) NO_SYSCALL_STUB;
          mkfifo_extended: 291, # int mkfifo_extended(user_addr_t path, uid_t uid, gid_t gid, int mode, user_addr_t xsecurity) NO_SYSCALL_STUB;
          mkdir_extended: 292, # int mkdir_extended(user_addr_t path, uid_t uid, gid_t gid, int mode, user_addr_t xsecurity) NO_SYSCALL_STUB;
          identitysvc: 293, # int identitysvc(int opcode, user_addr_t message) NO_SYSCALL_STUB;
          shared_region_check_np: 294, # int shared_region_check_np(uint64_t *start_address) NO_SYSCALL_STUB;
          shared_region_map_np: 295, # int shared_region_map_np(int fd, uint32_t count, const struct shared_file_mapping_np *mappings) NO_SYSCALL_STUB;
          vm_pressure_monitor: 296, # int vm_pressure_monitor(int wait_for_pressure, int nsecs_monitored, uint32_t *pages_reclaimed);
          psynch_rw_longrdlock: 297, # uint32_t psynch_rw_longrdlock(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_yieldwrlock: 298, # uint32_t psynch_rw_yieldwrlock(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_downgrade: 299, # int psynch_rw_downgrade(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_upgrade: 300, # uint32_t psynch_rw_upgrade(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_mutexwait: 301, # uint32_t psynch_mutexwait(user_addr_t mutex,  uint32_t mgen, uint32_t  ugen, uint64_t tid, uint32_t flags) NO_SYSCALL_STUB;
          psynch_mutexdrop: 302, # uint32_t psynch_mutexdrop(user_addr_t mutex,  uint32_t mgen, uint32_t  ugen, uint64_t tid, uint32_t flags) NO_SYSCALL_STUB;
          psynch_cvbroad: 303, # int psynch_cvbroad(user_addr_t cv, uint32_t cvgen, uint32_t diffgen, user_addr_t mutex,  uint32_t mgen, uint32_t ugen, uint64_t tid, uint32_t flags) NO_SYSCALL_STUB;
          psynch_cvsignal: 304, # int psynch_cvsignal(user_addr_t cv, uint32_t cvgen, uint32_t cvugen, user_addr_t mutex,  uint32_t mgen, uint32_t ugen, int thread_port, uint32_t flags) NO_SYSCALL_STUB;
          psynch_cvwait: 305, # uint32_t psynch_cvwait(user_addr_t cv, uint32_t cvgen, uint32_t cvugen, user_addr_t mutex,  uint32_t mgen, uint32_t ugen, uint64_t sec, uint64_t usec) NO_SYSCALL_STUB;
          psynch_rw_rdlock: 306, # uint32_t psynch_rw_rdlock(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_wrlock: 307, # uint32_t psynch_rw_wrlock(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_unlock: 308, # uint32_t psynch_rw_unlock(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          psynch_rw_unlock2: 309, # uint32_t psynch_rw_unlock2(user_addr_t rwlock, uint32_t lgenval, uint32_t ugenval, uint32_t rw_wc, int flags)  NO_SYSCALL_STUB;
          getsid: 310, # int getsid(pid_t pid);
          settid_with_pid: 311, # int settid_with_pid(pid_t pid, int assume) NO_SYSCALL_STUB;
          old__pthread_cond_timedwait: 312, # int nosys(void); } { old __pthread_cond_timedwait
          aio_fsync: 313, # int aio_fsync(int op, user_addr_t aiocbp);
          aio_return: 314, # user_ssize_t aio_return(user_addr_t aiocbp);
          aio_suspend: 315, # int aio_suspend(user_addr_t aiocblist, int nent, user_addr_t timeoutp);
          aio_cancel: 316, # int aio_cancel(int fd, user_addr_t aiocbp);
          aio_error: 317, # int aio_error(user_addr_t aiocbp);
          aio_read: 318, # int aio_read(user_addr_t aiocbp);
          aio_write: 319, # int aio_write(user_addr_t aiocbp);
          lio_listio: 320, # int lio_listio(int mode, user_addr_t aiocblist, int nent, user_addr_t sigp);
          old__pthread_cond_wait: 321, # int nosys(void); } { old __pthread_cond_wait
          iopolicysys: 322, # int iopolicysys(int cmd, void *arg) NO_SYSCALL_STUB;
          mlockall: 324, # int mlockall(int how);
          munlockall: 325, # int munlockall(int how);
          issetugid: 327, # int issetugid(void);
          __pthread_kill: 328, # int __pthread_kill(int thread_port, int sig);
          __pthread_sigmask: 329, # int __pthread_sigmask(int how, user_addr_t set, user_addr_t oset);
          __sigwait: 330, # int __sigwait(user_addr_t set, user_addr_t sig);
          __disable_threadsignal: 331, # int __disable_threadsignal(int value);
          __pthread_markcancel: 332, # int __pthread_markcancel(int thread_port);
          __pthread_canceled: 333, # int __pthread_canceled(int  action);
          __semwait_signal: 334, # int __semwait_signal(int cond_sem, int mutex_sem, int timeout, int relative, int64_t tv_sec, int32_t tv_nsec);
          old_utrace: 335, # int nosys(void); }   { old utrace
          proc_info: 336, # int proc_info(int32_t callnum,int32_t pid,uint32_t flavor, uint64_t arg,user_addr_t buffer,int32_t buffersize) NO_SYSCALL_STUB;
          sendfile: 337, # int sendfile(int fd, int s, off_t offset, off_t *nbytes, struct sf_hdtr *hdtr, int flags);
          stat64: 338, # int stat64(user_addr_t path, user_addr_t ub);
          fstat64: 339, # int fstat64(int fd, user_addr_t ub);
          lstat64: 340, # int lstat64(user_addr_t path, user_addr_t ub);
          stat64_extended: 341, # int stat64_extended(user_addr_t path, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          lstat64_extended: 342, # int lstat64_extended(user_addr_t path, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          fstat64_extended: 343, # int fstat64_extended(int fd, user_addr_t ub, user_addr_t xsecurity, user_addr_t xsecurity_size) NO_SYSCALL_STUB;
          getdirentries64: 344, # user_ssize_t getdirentries64(int fd, void *buf, user_size_t bufsize, off_t *position) NO_SYSCALL_STUB;
          statfs64: 345, # int statfs64(char *path, struct statfs64 *buf);
          fstatfs64: 346, # int fstatfs64(int fd, struct statfs64 *buf);
          getfsstat64: 347, # int getfsstat64(user_addr_t buf, int bufsize, int flags);
          __pthread_chdir: 348, # int __pthread_chdir(user_addr_t path);
          __pthread_fchdir: 349, # int __pthread_fchdir(int fd);
          audit: 350, # int audit(void *record, int length);
          auditon: 351, # int auditon(int cmd, void *data, int length);
          getauid: 353, # int getauid(au_id_t *auid);
          setauid: 354, # int setauid(au_id_t *auid);
          getaudit: 355, # int getaudit(struct auditinfo *auditinfo);
          setaudit: 356, # int setaudit(struct auditinfo *auditinfo);
          getaudit_addr: 357, # int getaudit_addr(struct auditinfo_addr *auditinfo_addr, int length);
          setaudit_addr: 358, # int setaudit_addr(struct auditinfo_addr *auditinfo_addr, int length);
          auditctl: 359, # int auditctl(char *path);
          bsdthread_create: 360, # user_addr_t bsdthread_create(user_addr_t func, user_addr_t func_arg, user_addr_t stack, user_addr_t pthread, uint32_t flags) NO_SYSCALL_STUB;
          bsdthread_terminate: 361, # int bsdthread_terminate(user_addr_t stackaddr, size_t freesize, uint32_t port, uint32_t sem) NO_SYSCALL_STUB;
          kqueue: 362, # int kqueue(void);
          kevent: 363, # int kevent(int fd, const struct kevent *changelist, int nchanges, struct kevent *eventlist, int nevents, const struct timespec *timeout);
          lchown: 364, # int lchown(user_addr_t path, uid_t owner, gid_t group);
          stack_snapshot: 365, # int stack_snapshot(pid_t pid, user_addr_t tracebuf, uint32_t tracebuf_size, uint32_t options) NO_SYSCALL_STUB;
          bsdthread_register: 366, # int bsdthread_register(user_addr_t threadstart, user_addr_t wqthread, int pthsize,user_addr_t dummy_value, user_addr_t targetconc_ptr, uint64_t dispatchqueue_offset) NO_SYSCALL_STUB;
          workq_open: 367, # int workq_open(void) NO_SYSCALL_STUB;
          workq_kernreturn: 368, # int workq_kernreturn(int options, user_addr_t item, int affinity, int prio) NO_SYSCALL_STUB;
          kevent64: 369, # int kevent64(int fd, const struct kevent64_s *changelist, int nchanges, struct kevent64_s *eventlist, int nevents, unsigned int flags, const struct timespec *timeout);
          old__semwait_signal: 370, # int nosys(void); }   { old __semwait_signal
          old_semwait_signal: 371, # int nosys(void); }   { old __semwait_signal
          thread_selfid: 372, # user_addr_t thread_selfid (void) NO_SYSCALL_STUB;
          __mac_execve: 380, # int __mac_execve(char *fname, char **argp, char **envp, struct mac *mac_p);
          __mac_syscall: 381, # int __mac_syscall(char *policy, int call, user_addr_t arg);
          __mac_get_file: 382, # int __mac_get_file(char *path_p, struct mac *mac_p);
          __mac_set_file: 383, # int __mac_set_file(char *path_p, struct mac *mac_p);
          __mac_get_link: 384, # int __mac_get_link(char *path_p, struct mac *mac_p);
          __mac_set_link: 385, # int __mac_set_link(char *path_p, struct mac *mac_p);
          __mac_get_proc: 386, # int __mac_get_proc(struct mac *mac_p);
          __mac_set_proc: 387, # int __mac_set_proc(struct mac *mac_p);
          __mac_get_fd: 388, # int __mac_get_fd(int fd, struct mac *mac_p);
          __mac_set_fd: 389, # int __mac_set_fd(int fd, struct mac *mac_p);
          __mac_get_pid: 390, # int __mac_get_pid(pid_t pid, struct mac *mac_p);
          __mac_get_lcid: 391, # int __mac_get_lcid(pid_t lcid, struct mac *mac_p);
          __mac_get_lctx: 392, # int __mac_get_lctx(struct mac *mac_p);
          __mac_set_lctx: 393, # int __mac_set_lctx(struct mac *mac_p);
          setlcid: 394, # int setlcid(pid_t pid, pid_t lcid) NO_SYSCALL_STUB;
          getlcid: 395, # int getlcid(pid_t pid) NO_SYSCALL_STUB;
          read_nocancel: 396, # user_ssize_t read_nocancel(int fd, user_addr_t cbuf, user_size_t nbyte) NO_SYSCALL_STUB;
          write_nocancel: 397, # user_ssize_t write_nocancel(int fd, user_addr_t cbuf, user_size_t nbyte) NO_SYSCALL_STUB;
          open_nocancel: 398, # int open_nocancel(user_addr_t path, int flags, int mode) NO_SYSCALL_STUB;
          close_nocancel: 399, # int close_nocancel(int fd) NO_SYSCALL_STUB;
          wait4_nocancel: 400, # int wait4_nocancel(int pid, user_addr_t status, int options, user_addr_t rusage) NO_SYSCALL_STUB;
          recvmsg_nocancel: 401, # int recvmsg_nocancel(int s, struct msghdr *msg, int flags) NO_SYSCALL_STUB;
          sendmsg_nocancel: 402, # int sendmsg_nocancel(int s, caddr_t msg, int flags) NO_SYSCALL_STUB;
          recvfrom_nocancel: 403, # int recvfrom_nocancel(int s, void *buf, size_t len, int flags, struct sockaddr *from, int *fromlenaddr) NO_SYSCALL_STUB;
          accept_nocancel: 404, # int accept_nocancel(int s, caddr_t name, socklen_t
          msync_nocancel: 405, # int msync_nocancel(caddr_t addr, size_t len, int flags) NO_SYSCALL_STUB;
          fcntl_nocancel: 406, # int fcntl_nocancel(int fd, int cmd, long arg) NO_SYSCALL_STUB;
          select_nocancel: 407, # int select_nocancel(int nd, u_int32_t *in, u_int32_t *ou, u_int32_t *ex, struct timeval *tv) NO_SYSCALL_STUB;
          fsync_nocancel: 408, # int fsync_nocancel(int fd) NO_SYSCALL_STUB;
          connect_nocancel: 409, # int connect_nocancel(int s, caddr_t name, socklen_t namelen) NO_SYSCALL_STUB;
          sigsuspend_nocancel: 410, # int sigsuspend_nocancel(sigset_t mask) NO_SYSCALL_STUB;
          readv_nocancel: 411, # user_ssize_t readv_nocancel(int fd, struct iovec *iovp, u_int iovcnt) NO_SYSCALL_STUB;
          writev_nocancel: 412, # user_ssize_t writev_nocancel(int fd, struct iovec *iovp, u_int iovcnt) NO_SYSCALL_STUB;
          sendto_nocancel: 413, # int sendto_nocancel(int s, caddr_t buf, size_t len, int flags, caddr_t to, socklen_t tolen) NO_SYSCALL_STUB;
          pread_nocancel: 414, # user_ssize_t pread_nocancel(int fd, user_addr_t buf, user_size_t nbyte, off_t offset) NO_SYSCALL_STUB;
          pwrite_nocancel: 415, # user_ssize_t pwrite_nocancel(int fd, user_addr_t buf, user_size_t nbyte, off_t offset) NO_SYSCALL_STUB;
          waitid_nocancel: 416, # int waitid_nocancel(idtype_t idtype, id_t id, siginfo_t *infop, int options) NO_SYSCALL_STUB;
          poll_nocancel: 417, # int poll_nocancel(struct pollfd *fds, u_int nfds, int timeout) NO_SYSCALL_STUB;
          msgsnd_nocancel: 418, # int msgsnd_nocancel(int msqid, void *msgp, size_t msgsz, int msgflg) NO_SYSCALL_STUB;
          msgrcv_nocancel: 419, # user_ssize_t msgrcv_nocancel(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg) NO_SYSCALL_STUB;
          sem_wait_nocancel: 420, # int sem_wait_nocancel(sem_t *sem) NO_SYSCALL_STUB;
          aio_suspend_nocancel: 421, # int aio_suspend_nocancel(user_addr_t aiocblist, int nent, user_addr_t timeoutp) NO_SYSCALL_STUB;
          __sigwait_nocancel: 422, # int __sigwait_nocancel(user_addr_t set, user_addr_t sig) NO_SYSCALL_STUB;
          __semwait_signal_nocancel: 423, # int __semwait_signal_nocancel(int cond_sem, int mutex_sem, int timeout, int relative, int64_t tv_sec, int32_t tv_nsec) NO_SYSCALL_STUB;}
          __mac_mount: 424, # int __mac_mount(char *type, char *path, int flags, caddr_t data, struct mac *mac_p);
          __mac_get_mount: 425, # int __mac_get_mount(char *path, struct mac *mac_p);
          __mac_getfsstat: 426, # int __mac_getfsstat(user_addr_t buf, int bufsize, user_addr_t mac, int macsize, int flags);
          fsgetpath: 427, # user_ssize_t fsgetpath(user_addr_t buf, size_t bufsize, user_addr_t fsid, uint64_t objid) NO_SYSCALL_STUB; } { private fsgetpath (File Manager SPI)
          audit_session_self: 428, # mach_port_name_t audit_session_self(void);
          audit_session_join: 429 # int audit_session_join(mach_port_name_t port);
        }
      end
    end
  end
end
