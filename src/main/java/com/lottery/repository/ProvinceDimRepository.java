package com.lottery.repository;

import com.lottery.entity.ETLLog;
import com.lottery.entity.ProvinceDim;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProvinceDimRepository extends JpaRepository<ProvinceDim, Long> {
}
