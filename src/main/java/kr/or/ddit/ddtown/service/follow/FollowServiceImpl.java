package kr.or.ddit.ddtown.service.follow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.ddtown.mapper.community.ICommunityFollowMapper;
import kr.or.ddit.vo.artist.ArtistGroupVO;
import kr.or.ddit.vo.follow.FollowVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FollowServiceImpl implements IFollowService {

	@Autowired
	private ICommunityFollowMapper followMapper;

	@Override
	public List<ArtistGroupVO> getFollowedArtistGroups(String username) throws Exception {
		log.debug("getFollowedArtistGroups() 실행...! 회원 - {}", username);
		return followMapper.selectFollowedArtistGroups(username);
	}

	@Override
	public ServiceResult follow(String followerUsername, int artGroupNo) throws Exception {
		log.debug("follow() 실행...! 팔로워 - {}, 팔로우 대상 그룹 - {}", followerUsername, artGroupNo);

		// 이미 팔로우 하고 있는지 체크
		if(isFollowing(followerUsername, artGroupNo)) {
			log.warn("이미 팔로우 중인 대상입니다. (사용자: {}, 그룹: {})", followerUsername, artGroupNo);
			return ServiceResult.EXIST;
		}

		int result = followMapper.insertFollow(followerUsername, artGroupNo);

		if(result > 0) {
			log.info("회원 {}가 그룹 {} 팔로우 성공!!", followerUsername, artGroupNo);
			return ServiceResult.OK;
		} else {
			log.error("팔로우 정보 저장 실패!! follower: {}, artGroupNo: {}", followerUsername, artGroupNo);
			return ServiceResult.FAILED;
		}

	}

	@Override
	public boolean isFollowing(String followerUsername, int artGroupNo) throws Exception {
		return followMapper.checkFollowExists(followerUsername, artGroupNo ) > 0;
	}

	@Override
	public int getFollowerCnt(int artGroupNo) throws Exception {
		log.info("getFollowerCnt() 실행...! 대상 아티스트 그룹번호: {}", artGroupNo);
		return followMapper.selectFollowerCnt(artGroupNo);
	}

	@Override
	public int getFollowingCnt(String username) throws Exception {
		log.info("getFollowingCnt() 실행...! 회원: {}", username);
		return followMapper.selectFollowingCnt(username);
	}

	// 특정 회원의 팔로우 목록 조회
	@Override
	public List<FollowVO> getFollowList(String username) {
		return followMapper.getFollowList(username);
	}

	@Override
	public List<String> getFollowerUsernamesForAlert(int artGroupNo) {
		log.debug("getFollowerUsernamesForAlert() 실행...! 대상 아티스트 그룹번호 : {}", artGroupNo);
		return followMapper.selectFollowersByArtGroup(artGroupNo);
	}

}
