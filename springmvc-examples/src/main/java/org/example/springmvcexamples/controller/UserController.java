package org.example.springmvcexamples.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.springmvcexamples.dox.User;
import org.example.springmvcexamples.service.UserService;
import org.example.springmvcexamples.vo.ResultVO;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/user/")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;

    @PatchMapping("password")
    public ResultVO patchPassword(@RequestBody User user,@RequestAttribute("uid") String uid) {
        userService.updateUserPasswordById(uid,user.getPassword());
        return ResultVO.ok();
    }
}
