package com.lottery.repository;

import com.lottery.entity.ETLLog;
import com.lottery.entity.StagingLottery;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StagingLotteryRepository extends JpaRepository<StagingLottery, Long> {
}
