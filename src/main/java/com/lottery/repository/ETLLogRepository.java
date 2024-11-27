package com.lottery.repository;

import com.lottery.entity.ETLLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ETLLogRepository extends JpaRepository<ETLLog, Long> {
}
