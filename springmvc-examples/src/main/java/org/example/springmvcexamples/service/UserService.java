package org.example.springmvcexamples.service;



import lombok.RequiredArgsConstructor;
import org.example.springmvcexamples.dox.User;
import org.example.springmvcexamples.exception.Code;
import org.example.springmvcexamples.exception.XException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    private final PasswordEncoder passwordEncoder;

    private static final Set<User> USERS = creat();
    private static Set<User> creat() {
        User u1 = User.builder()
                .id("1")
                .name("王思迪")
                .account("2022212916")
                .password("$2a$10$vbic.eN8nCmnzExjVIUUwOKsIAz0.NGEYC/IGwjWJHSCC8s37Kn9G")
                .departmentId("001")
                .role(User.STUDENT)
                .student("""
                         {
                           "teacherId": "2",
                           "projectTitle": "毕设管理系统",
                           "group_order": 4,
                           "auth": 2
                         }
                         """
                        )
                .groupNumber(4)
                .build();
        User u2 = User.builder()
                .id("2")
                .name("王波")
                .account("1022212916")
                .password("$2a$10$vbic.eN8nCmnzExjVIUUwOKsIAz0.NGEYC/IGwjWJHSCC8s37Kn9G")
                .departmentId("001")
                .role(User.TEACHER)
                .teacher("""
                        {
                           "teachNumber": 5,
                           "A": 2,
                           "C": 2,
                           "auth": 1
                        }
                        """
                )
                .groupNumber(4)
                .build();
        User u3 = User.builder()
                .id("3")
                .name("admin")
                .account("3022212916")
                .password("$2a$10$vbic.eN8nCmnzExjVIUUwOKsIAz0.NGEYC/IGwjWJHSCC8s37Kn9G")
                .departmentId("001")
                .role(User.ADMIN)
                .build();
        Set<User> users = new HashSet<>();
        users.add(u1);
        users.add(u2);
        users.add(u3);
        return users;
    }

    public Set<User> setUsers() {
        return USERS;
    }

    public User getUserByAccount(String account) {
        return USERS.stream()
                .filter( u -> u.getAccount().equals(account))
                .findFirst()
                .orElse(null);
    }

    public User getUserById(String id) {
        return USERS.stream()
                .filter( u -> u.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public void updateUserPasswordById(String uid, String password) {
        User u = getUserById(uid);
        if(u == null) {
            throw XException.builder()
                    .number(Code.ERROR)
                    .message("用户不存在")
                    .build();
        }
        u.setPassword(passwordEncoder.encode(password));
    }

}
