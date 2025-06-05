create table if not exists `department`
(
    id          char(19)       not null primary key,
    name        varchar(20)    not null,
    insert_time datetime       not null default current_timestamp,
    update_time datetime       not null default current_timestamp on update current_timestamp
);

create table if not exists `user`
(
    id            char(19)         not null primary key,
    account       char(10)      unique not null,
    password      varchar(65)      not null,
    name          varchar(8)      not null,
    department_id char(19)         not null,
    role          varchar(20)      not null,
    group_number  tinyint unsigned null,
    student       json             null comment '{"teacherId", "projectTitle", "group_order"， "auth"}', -- 添加组内顺序，自动生成后填入
    teacher       json             null comment '{"teachNumber", "A", "C", "auth"}', -- 添加A,C组, 分组后填入
    insert_time   datetime         not null default current_timestamp,
    update_time   datetime         not null default current_timestamp on update current_timestamp,

    index((cast( student ->> '$.teacherId' as char(19)) collate utf8mb4_bin)), -- 搜索指导老师的学生
    index(department_id, group_number, role)  -- 查询某个专业的第几组的老师或者学生
);

create table if not exists `process`
(
    id              char(19)           not null primary key,
    name            varchar(20)        not null,
    items           json               comment '[{"number", "name", "point", "description"}]',
    proportion      tinyint unsigned   not null,
    department_id   char(19)           not null,
    auth            varchar(10)        not null,  -- 每个过程定义对应权限
    file            json               null comment '[{"id", "name", "type", "path"}]',
    insert_time     datetime           not null default current_timestamp,
    update_time     datetime           not null default current_timestamp on update current_timestamp,

    index(department_id, (cast( items ->> '$.number' as char(19)) collate utf8mb4_bin)) -- 查询专业和查询专业的的过程子项
);

create table if not exists `process_score`
(
    id            char(19)    not null primary key,
    student_id    char(19)    not null,
    process_id    char(19)    not null,
    teacher_id    char(19)    not null,
    detail        json        not null comment '{"score", item: [{"number", "name", "score"}]}',
    insert_time   datetime    not null default current_timestamp,
    update_time   datetime    not null default current_timestamp on update current_timestamp,

    unique(process_id, student_id, teacher_id) -- 从左到右，先查过程ID,再查学生ID，通过user表确定第几组和其老师，确定由哪个老师打分
);                                             -- 查询某个过程的所有学生的分数